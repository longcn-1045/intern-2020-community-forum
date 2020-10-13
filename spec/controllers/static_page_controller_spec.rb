require "rails_helper"

RSpec.describe StaticPagesController, type: :controller do
  let!(:user_test) {FactoryBot.create :user, role: :member}
  let!(:post_test) {FactoryBot.create :post,
                                      user: user_test,
                                      status: "on",
                                      created_at: "14-04-2020"}

  describe "GET #home" do
    before {get :home, params: {page: 1}}

    context "as a guest"  do
      it {expect(response).to redirect_to new_user_session_path(locale: nil)}
    end

    context "as an  authenticated user" do
      before {login user_test}
      let!(:post_two) do
        FactoryBot.create :post,
                          title: "Ngoc Long",
                          created_at: "15-04-2020",
                          updated_at: "15-04-2020",
                          user: user_test,
                          status: "on"
      end
      let!(:post_three) do
        FactoryBot.create :post,
                          title: "Minh Thong",
                          created_at: "16-04-2020",
                          updated_at: "16-04-2020",
                          user: user_test,
                          status: "on"
      end

      before {get :home, params: {page: 1}}

      it {expect(response).to render_template :home}

      it {expect(assigns(:posts).pluck(:id)).to eq [post_three.id, post_two.id, post_test.id]}
    end
  end
end
