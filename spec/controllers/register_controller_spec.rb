require "rails_helper"

RSpec.describe Admin::RegistersController, type: :controller do
  before {@request.env["devise.mapping"] = Devise.mappings[:user]}

  describe "GET #new" do
    it "should show new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    let(:valid_user_params) do
      {
        user: {
          name: "Lebara",
          email: "abc@gmail.com",
          password: "123456",
          role: "member"
        }
      }
    end

    let(:invalid_user_params) do
      {
        user: {
          name: "Lebara",
          email: "abc@gmail.com",
          password: "1",
          role: "member"
        }
      }
    end

    context "when a valid param" do
      it "should redirect to login_pages" do
        post :create, params: valid_user_params
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when a invalid param" do
      it "should redirect to login_pages" do
        post :create, params: invalid_user_params
        expect(response).to render_template :new
      end
    end
  end
end
