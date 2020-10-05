require "rails_helper"

RSpec.describe PostCommentsController, type: :controller do
  let!(:test_comment) {FactoryBot.create :post_comment}
  let!(:user_test) {FactoryBot.create :user, role: :member}
  let!(:post_test) {FactoryBot.create :post}

  describe "POST #create" do
    let(:comment_params) do
      {
        locale: "en",
        post_id: post_test.id,
        post_comment: {
          user: user_test,
          content: "Aloha",
          commentable: post_test
        },
        format: :js
      }
    end
    let(:invalid_comment_params) do
      {
        locale: "en",
        post_id: post_test.id,
        post_comment: {
          user: user_test,
          content: nil,
          commentable: post_test
        },
        format: :js
      }
    end

    before {login user_test}

    context "when valid params" do
      it "should correct comment content" do
        expect{
          post :create, params: comment_params
        }.to change(PostComment, :count).by 1
      end

      it "response 200 with json success: true" do
        post :create, params: comment_params
        expect(assigns(:error)).to eq nil
      end
    end

    context "when invalid params" do
      before{post :create, params: invalid_comment_params}
      it "should a invalid post" do
        expect{
          subject
        }.to change(PostComment, :count).by 0
      end

      it "response 200 with json error: true" do
        post :create, params: invalid_comment_params
        expect(assigns(:error)).not_to eq nil
      end
    end
  end
end
