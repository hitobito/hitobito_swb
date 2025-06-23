# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

require "spec_helper"

describe "hitobito_log_entries/_list.html.haml" do
  let(:dom) {
    render
    Capybara::Node::Simple.new(@rendered)
  }

  it "links to person for role subject" do
    entries = Kaminari.paginate_array([
      Fabricate(:ts_log, subject: roles(:leader))
    ])
    allow(entries).to receive_messages(total_pages: 1, current_page: 1)
    allow(view).to receive_messages(model_class: HitobitoLogEntry, category_param: "", entries: entries)
    expect(dom).to have_link("A Leader", href: "/de/people/#{people(:leader).id}")
  end

  it "links to person for person subject" do
    entries = Kaminari.paginate_array([
      Fabricate(:ts_log, subject: people(:leader))
    ])
    allow(entries).to receive_messages(total_pages: 1, current_page: 1)
    allow(view).to receive_messages(model_class: HitobitoLogEntry, category_param: "", entries: entries, can?: true)
    expect(dom).to have_link("A Leader", href: "/de/people/#{people(:leader).id}")
  end
end
