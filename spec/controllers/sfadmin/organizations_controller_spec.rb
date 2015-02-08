require "rails_helper"

describe Sfadmin::OrganizationsController do
  include Devise::TestHelpers

  describe "#update" do
    it "permits the name to be updated" do
      organization = create :organization, name: "Example"
      updated_name = "Updated Name"

      sign_in create(:admin)
      put(
        :update,
        id: organization,
        organization: { name: updated_name },
      )

      organization.reload
      expect(organization.name).to eq updated_name
    end

    it "permits the URLs to be updated" do
      organization = create(
        :organization,
        urls: ["http://example.com", "http://foobar.com"],
      )
      updated_urls = ["http://foobarbaz.com"]

      sign_in create(:admin)
      put(
        :update,
        id: organization,
        organization: { urls: updated_urls },
      )

      organization.reload
      expect(organization.urls).to eq updated_urls
    end
  end
end
