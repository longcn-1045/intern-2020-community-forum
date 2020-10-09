require "rails_helper"

RSpec.describe PostReportsController, type: :controller do
  let!(:test_report) {FactoryBot.create :post_report}
  let!(:user_test) {FactoryBot.create :user, role: :member}
  let!(:post_test) {FactoryBot.create :post}
  let!(:report_reason_test) {FactoryBot.create :report_reason}

  describe "POST #create" do
    let(:post_report_params) do
      {
        locale: "en",
        user_id: user_test.id,
        post_id: post_test.id,
        report_reason_id: report_reason_test.id,
        format: :js
      }
    end
    let(:invalid_post_report_params) do
      {
        locale: "en",
        user_id: user_test.id,
        post_id: post_test.id,
        report_reason_id: nil,
        format: :js
      }
    end

    before {login user_test}

    context "when valid params" do
      it "should correct comment content" do
        expect{
          post :create, params: post_report_params
        }.to change(PostReport, :count).by 1
      end

      it "response 200 with json success: true" do
        post :create, params: post_report_params
        expect(flash[:notice]).to eq I18n.t("post_reports.create.report_created")
      end
    end

    context "when invalid params" do
      before{post :create, params: invalid_post_report_params}
      it "should a invalid post" do
        expect{
          subject
        }.to change(PostReport, :count).by 0
      end

      it "response 200 with json error: true" do
        post :create, params: invalid_post_report_params
        expect(flash[:alert]).to eq I18n.t("post_reports.create.report_create_failed")
      end
    end
  end
end
