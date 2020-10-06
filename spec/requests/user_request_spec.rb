require "rails_helper"

RSpec.describe Admin::UsersController, type: :controller do
  let!(:user_1) {FactoryBot.create :user,
    created_at: "2020-09-06 05:48:12", role: "admin"}
  let!(:user_2) {FactoryBot.create :user,
    created_at: "2020-09-07 05:48:12"}
  let(:valid_param) {FactoryBot.attributes_for :user}
  let(:invalid_param) {FactoryBot.attributes_for :user, name: nil}

  describe "GET #index" do
    before {get :index, params: {page: 1}}

    context "as a guest"  do
      it {expect(response).to redirect_to new_user_session_path(locale: nil)}
    end

    context "as an  authenticated user" do
      let!(:user_3) {FactoryBot.create :user,
        created_at: "2020-09-08 05:48:12"}

      before {login user_1}

      before {get :index, params: {page: 1}}

      it {expect(response).to render_template :index}

      it {expect(assigns(:users).pluck(:id)).to eq [user_3.id, user_2.id, user_1.id]}
    end
  end

  describe "GET #show" do
    context "as a guest"  do
      before {logout user_1}
      before {get :show, params: {id: user_1.id}}
      it {expect(response).to redirect_to new_user_session_path(locale: nil)}
    end

    before {login user_1}

    context "when valid param" do
      before {get :show, params: {id: user_1.id}}

      it "assigns @user" do
        expect(assigns(:user)).to eq user_1
      end

      it "should render 'show' template" do
        expect(response).to render_template :show
      end
    end

    context "when invalid param" do
      before {get :show, params: {id: "abc"}}

      it "should have a invalid posts" do
        expect(assigns(:user)).to eq nil
      end

      it "should redirect to admin_root_url" do
        expect(response).to redirect_to admin_root_url
      end
    end
  end

  describe "GET #edit" do
    context "as a guest"  do
      before {logout user_1}
      before {get :edit, params: {id: user_1.id}}
      it {expect(response).to redirect_to new_user_session_path(locale: nil)}
    end

    before {login user_1}

    context "when valid param" do
      before {get :edit, params: {id: user_1.id}}

      it "assigns @user" do
        expect(assigns(:user)).to eq user_1
      end

      it "should render 'edit' template" do
        expect(response).to render_template :edit
      end
    end

    context "when invalid param" do
      before {get :edit, params: {id: "abc"}}

      it "should have a invalid posts" do
        expect(assigns(:user)).to eq nil
      end

      it "should redirect to admin_root_url" do
        expect(response).to redirect_to admin_root_url
      end
    end
  end

  describe "PATCH #update" do
    context "as a guest"  do
      before {logout user_1}
      before {patch :update, params: {id: user_1.id, user: {name: "Test update"}}}
      it {expect(response).to redirect_to new_user_session_path(locale: nil)}
    end

    before {login user_1}

    context "when valid params" do
      before {patch :update, params: {id: user_2.id, user: {name: "Test update"}}}
      it "should correct name" do
        expect(assigns(:user).name).to eq "Test update"
      end

      it "should redirect admin_users_path" do
        expect(response).to redirect_to admin_users_path
      end
    end

    context "when invalid params" do
      before { patch :update, params: {id: user_2.id, user: invalid_param} }

      it "should a invalid user" do
        expect(assigns(:user).invalid?).to eq true
      end

      it "should render edit template" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:user_destroy) {FactoryBot.create :user, name: "test data"}

    context "as a guest"  do
      before {logout user_1}
      before {delete :destroy, params: {id: user_destroy.id}}
      it {expect(response).to redirect_to new_user_session_path(locale: nil)}
    end

    before {login user_1}

    context "when valid params" do
      before {delete :destroy, params: {id: user_destroy.id}}

      it "should correct name" do
        expect(User.all).not_to include(user_destroy)
      end

      it "should redirect to admin_users_path" do
        expect(response).to redirect_to admin_users_path
      end
    end

    context "when a failure course destroy" do
      let!(:user_destroy_2) {FactoryBot.create :user, name: "test data"}

      before do
        allow_any_instance_of(User).to receive(:destroy).and_return false
        delete :destroy, params: {id: user_destroy_2.id}
      end

      it "flash error message" do
        expect(flash[:alert]).to eq I18n.t("users.controller.delete_fail")
      end

      it "should redirect to admin_users_path" do
        expect(response).to redirect_to admin_users_path
      end
    end
  end
end
