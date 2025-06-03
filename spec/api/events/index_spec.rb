# frozen_string_literal: true

#  Copyright (c) 2024, Schweizer Alpen-Club. This file is part of
#  hitobito_sac_cas and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_sac_cas.

require "spec_helper"

RSpec.describe "events#index", type: :request do
  it_behaves_like "jsonapi authorized requests", person: :admin do
    let!(:token) { service_tokens(:permitted_root_layer_token).token }
    let(:params) { {} }

    subject(:make_request) { jsonapi_get "/api/events", params: }

    context "caching" do
      let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }

      before do
        allow(Rails).to receive(:cache).and_return(memory_store)
        Rails.cache.clear
      end

      it "does not execute query again for same params" do
        expect(EventResource).to receive(:all).and_call_original.once
        2.times do
          jsonapi_get "/api/events"
          expect(response.status).to eq(200), response.body
          expect(json["data"]).to have(2).items
        end
      end

      it "does execute query twice if params differ" do
        expect(EventResource).to receive(:all).and_call_original.twice
        jsonapi_get "/api/events"
        jsonapi_get "/api/events", params: {page: {size: 2}}
      end

      it "does execute query again if Event updated_at changes" do
        expect(EventResource).to receive(:all).and_call_original.twice
        jsonapi_get "/api/events"
        travel_to(1.minute.from_now) do
          Event.last.touch
          jsonapi_get "/api/events"
        end
      end

      it "does execute query again if Event::Participation updated_at changes" do
        expect(EventResource).to receive(:all).and_call_original.twice
        jsonapi_get "/api/events"
        travel_to(1.minute.from_now) do
          Event::Participation.last.touch
          jsonapi_get "/api/events"
        end
        jsonapi_get "/api/events"
      end

      it "does execute query again if cache expired" do
        expect(EventResource).to receive(:all).and_call_original.twice
        jsonapi_get "/api/events"
        travel_to(3.hours.from_now + 1.minute) do
          jsonapi_get "/api/events"
        end
      end

      it "does execute query again if event dates changed" do
        expect(EventResource).to receive(:all).and_call_original.twice
        jsonapi_get "/api/events"
        Event.first.dates.first.update!(start_at: 50.days.ago)
        jsonapi_get "/api/events"
      end

      it "does execute query again if event date is deleted" do
        expect(EventResource).to receive(:all).and_call_original.twice
        jsonapi_get "/api/events"
        Event.first.dates.first.destroy!
        jsonapi_get "/api/events"
      end
    end
  end
end
