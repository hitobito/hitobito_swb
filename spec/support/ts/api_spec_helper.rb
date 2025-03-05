# frozen_string_literal: true

#  Copyright (c) 2012-2025, Swiss Badminton. This file is part of
#  hitobito_swb and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_swb.

module Ts::ApiSpecHelper
  extend ActiveSupport::Concern

  included do
    let(:url) { "https://ts.example.com/1.0/Organization/b7755b71-068e-44e7-a061-ab26991fd6be" }
    let(:headers) {
      {"Authorization" => "Basic dXNlcjpzM2N1cmU=",
       "Content-Type" => "text/xml",
       "Host" => "ts.example.com"}
    }
    let(:code) { Faker::Internet.uuid }
  end

  def stub_api_request(method, path, request_body: nil, response_body: nil, status: 200)
    stub_request(method, url + path)
      .with(headers: headers, body: request_body)
      .to_return(status:, body: response_body)
  end

  def sucessfull_response_body(*entities)
    entities_body = entities.map(&:to_xml).join("\n")
    <<~XML
      <?xml version="1.0" encoding="utf-8"?>
      <Result Version="1.0">
       #{Ts::Entity::Error.new(code: 0, message: "success").to_xml}
       #{entities_body}
      </Result>
    XML
  end

  def error_response_body(code: 123, message: "This operation failed")
    <<~XML
      <?xml version="1.0" encoding="utf-8"?>
      <Result Version="1.0">
       #{Ts::Entity::Error.new(code:, message:).to_xml}
      </Result>
    XML
  end
end
