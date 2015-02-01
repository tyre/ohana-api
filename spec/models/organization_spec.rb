require "rails_helper"

describe Organization do

  subject { build(:organization) }

  it { should be_valid }

  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:urls) }

  it { should have_many :locations }

  it { should validate_presence_of(:name) }

  it { should serialize(:urls).as(Array) }

  it { should allow_value("http://monfresh.com").for(:urls) }
  it { should_not allow_value("http://codeforamericaorg").for(:urls) }
  it { should_not allow_value("www.codeforamerica.org").for(:urls) }

  it do
    should_not allow_value("http://").for(:urls).with_message(/not a valid URL/)
  end

  describe "auto_strip_attributes" do
    it "strips extra whitespace before validation" do
      org = build(:org_with_extra_whitespace)
      org.valid?
      expect(org.name).to eq("Food Pantry")
      expect(org.urls).to eq(["http://cfa.org"])
    end
  end

  it { is_expected.to respond_to(:domain_name) }
  describe "#domain_name" do
    it "returns the domain part of the organization's first URL" do
      subject = build(:org_with_urls)
      expect(subject.domain_name).to eq("monfresh.com")
    end
  end

  describe "slug candidates" do
    context "when name is already taken" do
      it "creates a new slug" do
        create(:organization, name: "Parent Agency")

        new_org = Organization.create!(name: "Parent Agency")
        expect(new_org.reload.slug).not_to eq("parent-agency")
      end
    end

    context "when url is present and name is taken" do
      it "creates a new slug based on url" do
        create(:organization, name: "Parent Agency")

        new_org = Organization.create!(
          name: "Parent Agency",
          urls: ["http://monfresh.com"]
        )
        expect(new_org.reload.slug).to eq("parent-agency-monfresh-com")
      end
    end

    context "when name is not updated" do
      it "doesn't update slug" do
        org = create(:organization, name: "Parent Agency")

        org.update_attributes!(urls: ["http://monfresh.com"])
        expect(org.reload.slug).to eq("parent-agency")
      end
    end
  end
end
