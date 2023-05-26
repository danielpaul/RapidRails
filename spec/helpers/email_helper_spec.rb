require "rails_helper"

RSpec.describe "#open_email_inbox_url" do
  context "with a valid email address" do
    let(:email_address) { "test@gmail.com" }

    it "returns the correct Gmail URL" do
      expected_url = expected_url = "https://mail.google.com/mail/u/test%40gmail.com/#search/from%3Atest%2540gmail.com%20in%3Aanywhere%20newer_than%3A1d"
      expect(open_email_inbox_url(email_address)).to eq(expected_url)
    end
  end

  context "with an email address from a different domain" do
    let(:email_address) { "test@example.com" }

    it "returns the correct URL based on the domain" do
      expected_url = "https://example.com"
      expect(open_email_inbox_url(email_address)).to eq(expected_url)
    end
  end

  context "with an empty email address" do
    let(:email_address) { "" }

    it "returns nil" do
      expect(open_email_inbox_url(email_address)).to be_nil
    end
  end

  context "with an invalid email address" do
    let(:email_address) { "invalid_email" }

    it "returns nil" do
      expect(open_email_inbox_url(email_address)).to be_nil
    end
  end
end
