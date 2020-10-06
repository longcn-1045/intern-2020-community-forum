require "rails_helper"

RSpec.describe Admin::PostsController, type: :controller do
  let!(:test_post) {FactoryBot.create :post}
  let!(:user_test) {FactoryBot.create :user, role: :admin}
  let!(:topic_test) {FactoryBot.create :topic, status: :on}
  let!(:notification_test) {FactoryBot.create :notification, post: test_post}
  let(:valid_param) {FactoryBot.attributes_for :post}
  let(:invalid_param) {FactoryBot.attributes_for :post, title: nil, status: :on}

  describe "GET #index" do
    before {get :index, params: {page: 1}}

    context "as a guest"  do
      it {expect(response).to redirect_to new_user_session_path(locale: nil)}
    end

    context "as an  authenticated user" do
      before {login user_test}
      let!(:post_two) do
        FactoryBot.create :post,
                          title: "Ngoc Long",
                          created_at: "15-04-2020",
                          updated_at: "15-04-2020"
      end
      let!(:post_three) do
        FactoryBot.create :post,
                          title: "Minh Thong",
                          created_at: "16-04-2020",
                          updated_at: "16-04-2020"
      end

      before {get :index, params: {page: 1}}

      it {expect(response).to render_template :index}

      it {expect(assigns(:posts).pluck(:id)).to eq [notification_test.post.id, post_two.id, post_three.id]}
    end
  end

  describe "GET #edit" do
    context "as a guest"  do
      before {logout user_test}
      before {get :edit, params: {id: test_post.id}}
      it {expect(response).to redirect_to new_user_session_path(locale: nil)}
    end

    before {login user_test}

    context "when valid param" do
      before {get :edit, params: {id: test_post.id}}

      it "should have a valid course" do
        expect(assigns(:post).id).to eq test_post.id
      end

      it "should render edit template" do
        expect(response).to render_template :edit
      end
    end

    context "when invalid param" do
      before {get :edit, params: {id: "abc"}}

      it "should have a invalid post" do
        expect(assigns(:post)).to eq nil
      end

      it "should redirect to admin_posts_path" do
        expect(response).to redirect_to admin_posts_path
      end
    end
  end

  describe "PATCH #update" do
    context "as a guest"  do
      before {logout user_test}
      before {patch :update, params: {id: test_post.id, post: {title: "Test update"}}}
      it {expect(response).to redirect_to new_user_session_path(locale: nil)}
    end

    before {login user_test}

    context "when valid params" do
      before {patch :update, params: {id: test_post.id, post: {title: "Test update"}}}

      it "should correct title" do
        expect(assigns(:post).title).to eq "Test update"
      end

      it "should redirect admin_posts_path" do
        expect(response).to redirect_to admin_posts_path
      end
    end

    context "when invalid params" do
      before { patch :update, params: {id: test_post.id, post: invalid_param} }

      it "should a invalid post" do
        expect(assigns(:post).invalid?).to eq true
      end

      it "should render edit template" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "GET #show" do
    context "as a guest"  do
      before {logout user_test}
      before {get :show, params: {id: test_post.id}}
      it {expect(response).to redirect_to new_user_session_path(locale: nil)}
    end

    before {login user_test}

    context "when valid param" do
      before {get :show, params: {id: test_post.id}}

      it "should have a valid post" do
        expect(assigns(:post).id).to eq test_post.id
      end

      it "should render show template" do
        expect(response).to render_template :show
      end
    end

    context "when invalid param" do
      before {get :show, params: {id: "abc"}}

      it "should have a invalid post" do
        expect(assigns(:post)).to eq nil
      end

      it "should redirect to admin_posts_path" do
        expect(response).to redirect_to admin_posts_path
      end
    end

    context "when notification_id params present" do
      before {get :show, params: {id: test_post.id, notification_id: notification_test.id}}

      it "should have a valid post" do
        expect(assigns(:notify).viewed).to eq "checked"
      end
    end

    context "when notification_id params not present" do
      before {get :show, params: {id: test_post.id, notification_id: "abc"}}

      it "should redirect to admin_posts_path" do
        expect(response).to redirect_to admin_posts_path
      end
    end
  end

  describe "GET #new" do
    context "as a guest"  do
      before {logout user_test}
      before {get :new}
      it {expect(response).to redirect_to new_user_session_path(locale: nil)}
    end

    before {login user_test}

    before {get :new}
    it "should render new template" do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    let(:post_params) do
      {
        post: {
          title: "Lebara",
          topic_id: topic_test.id,
          content: "Lebara Lebara",
          status: "on"
        }
      }
    end
    let(:invalid_post_params) do
      {
        post: {
          title: nil,
          content: "Lebara Lebara",
          status: "on"
        }
      }
    end

    context "as a guest"  do
      before {logout user_test}
      before{post :create, params: invalid_post_params}
      it {expect(response).to redirect_to new_user_session_path(locale: nil)}
    end

    before {login user_test}

    context "when valid params" do
      it "should correct post name" do
        expect{
          post :create, params: post_params
        }.to change(Post, :count).by 1
      end

      it "should redirect to admin_posts_path" do
        post :create, params: post_params
        expect(response).to redirect_to admin_posts_path
      end
    end

    context "when invalid params" do
      before{post :create, params: invalid_post_params}
      it "should a invalid post" do
        expect{
          subject
        }.to change(Post, :count).by 0
      end

      it "should render new template" do
        expect(response).to render_template :new
      end
    end
  end

  describe "DELETE #destroy" do
    context "as a guest"  do
      before {logout user_test}
      before { delete :destroy, params: {id: test_post.id} }
      it {expect(response).to redirect_to new_user_session_path(locale: nil)}
    end

    before {login user_test}

    context "when valid params" do
      before { delete :destroy, params: {id: test_post.id} }

      it "should correct post" do
        expect(assigns(:post).destroyed?).to eq true
      end

      it "should redirect to admin_posts_path" do
        expect(response).to redirect_to admin_posts_path
      end
    end

    context "when invalid params" do
      before {delete :destroy, params: {id: "abc"}}

      it "should a invalid post" do
        expect{subject}.to change(Post, :count).by 0
      end

      it "should redirect to admin_posts_path" do
        expect(response).to redirect_to admin_posts_path
      end
    end

    context "when a failure post destroy" do
      before do
        allow_any_instance_of(Post).to receive(:destroy).and_return false
        delete :destroy, params: {id: test_post.id}
      end

      it "flash error message" do
        expect(flash[:alert]).to eq I18n.t("post.controller.deleted_error")
      end

      it "should redirect to admin_posts_path" do
        expect(response).to redirect_to admin_posts_path
      end
    end
  end

  describe "GET #post_process" do
    context "as a guest"  do
      before {logout user_test}
      before {get :post_process, params: {option: :on, id: test_post.id}}
      it {expect(response).to redirect_to new_user_session_path(locale: nil)}
    end

    before {login user_test}

    before {get :post_process, params: {option: :on, id: test_post.id}}

    it "should change post status" do
      expect(assigns(:post).status).to eq "on"
    end
  end
end
