require "rails_helper"

RSpec.describe Admin::SessionsController, type: :controller do
  before {@request.env["devise.mapping"] = Devise.mappings[:user]}

  describe "GET #new" do
    it "should show new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "when a valid param" do
      let!(:valid_user_admin){FactoryBot.create :user, role: :admin}
      let!(:valid_user_member){FactoryBot.create :user, role: :member}

      context "when a valid user" do
        it "should redirect to admin_dashboads if user is admin" do
          post :create, params: {user: {email: valid_user_admin.email, password: "Minhthong511"}}
          expect(response).to redirect_to admin_root_path
        end

        it "should redirect to trainers_courses_path if user is trainee" do
          post :create, params: {user: {email: valid_user_member.email, password: "Minhthong511"}}
          expect(response).to redirect_to static_pages_home_path
        end
      end

      context "when a invalid user" do
        it "should flash alert" do
          post :create, params: {user: {email: valid_user_admin.email, password: "1"}}
          expect(flash[:alert].present?).to eq true
        end
      end
    end

    context "when a invalid param" do
      it "should flash alert" do
        post :create, params: {user: {email: nil, password: "1"}}
        expect(flash[:alert].present?).to eq true
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      user = FactoryBot.create :user
      sign_in user
    end
    it "should redirect to new_user_session_path" do
      delete :destroy
      expect(response).to redirect_to new_user_session_path
    end
  end
end
