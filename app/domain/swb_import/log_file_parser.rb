module SwbImport
  class LogFileParser
    attr_reader :errors

    Error = Data.define(:name, :id, :role, :membership, :group_code)

    INVALID_ROLES_REGEX = /^(.*)\((\d+)\).*\((.*),(.*),(.*?)\)/

    def initialize(file = "log/04-07-08_02_55/4-roles-invalid.log")
      @errors = File.new(file)
        .readlines
        .map { |line| Error.new(*INVALID_ROLES_REGEX.match(line).captures) }
    end
  end
end
