# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module SwbImport
  class Pusher
    # rubocop:disable Rails/Output
    def push
      cluster_psql = "$HOME/dev/hitobito/hitobito-ops/bin/postgresql"
      pg_dump = "/usr/lib/postgresql/16/bin/pg_dump"
      db_dump = "tmp/dump.sql"
      puts "Setting offseting sequences by #{sequence_offset}"
      puts "Dumping local schema"
      ActiveRecord::Base.connection.execute "ALTER SCHEMA public RENAME TO database"
      system("PGPASSWORD=$RAILS_DB_PASSWORD #{pg_dump} -cOx -h $RAILS_DB_HOST -U $RAILS_DB_USERNAME $RAILS_DB_NAME > #{db_dump}")
      ActiveRecord::Base.connection.execute "ALTER SCHEMA database RENAME TO public"
      project = `oc project -q`.strip
      fail "Unexpected project: #{project}" unless project == "hit-swb-int"
      puts "Updating remote database"
      system("#{cluster_psql} < #{db_dump}")
    end
    # rubocop:enable Rails/Output

    def update_sequences
      sql = <<~SQL
        SELECT 'SELECT SETVAL(' ||
          quote_literal(quote_ident(PGT.schemaname) || '.' || quote_ident(S.relname)) ||
          ', COALESCE(MAX(' ||quote_ident(C.attname)|| '), 1) + #{sequence_offset}) FROM ' ||
          quote_ident(PGT.schemaname)|| '.'||quote_ident(T.relname)|| ';' as query
          FROM pg_class AS S,
          pg_depend AS D,
          pg_class AS T,
          pg_attribute AS C,
          pg_tables AS PGT
          WHERE S.relkind = 'S'
          AND T.relname IN ('groups', 'roles')
          AND S.oid = D.objid
          AND D.refobjid = T.oid
          AND D.refobjid = C.attrelid
          AND D.refobjsubid = C.attnum
          AND T.relname = PGT.tablename
          ORDER BY S.relname;
      SQL
      ActiveRecord::Base.connection.execute(sql).map do |query|
        ActiveRecord::Base.connection.execute(query["query"])
      end
    end

    def offset_file
      @offset_file ||= Wagons.all.first.root.join("tmp/sequence_offset.txt").tap do |file|
        file.write(0) unless file.exist?
      end
    end

    def sequence_offset
      @sequence_offset ||= (offset_file.read.to_i + SEQUENCE_OFFSET).tap do |offset|
        offset_file.write(offset)
      end
    end
  end
end
