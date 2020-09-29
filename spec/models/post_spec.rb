require "rails_helper"

RSpec.describe Post, type: :model do
  let(:post) {FactoryBot.build :post}
  let(:invalid_post) {FactoryBot.build :post, title: nil}
  let(:post_count) {Post.count}
  let!(:post_two) do
    FactoryBot.create :post,
                      title: "Ngoc Long",
                      created_at: "14-09-2020",
                      updated_at: "14-09-2020"
  end
  let!(:post_three) do
    FactoryBot.create :post,
                      title: "Minh Thong",
                      created_at: "15-09-2020",
                      updated_at: "15-09-2020"
  end

  describe "Validations" do
    it "valid all field" do
      expect(post.valid?).to eq true
    end

    it "invalid any field" do
      expect(invalid_post.valid?).to eq false
    end
  end

  describe "Enums" do
    it "role status" do
      is_expected.to define_enum_for(:status)
                 .with_values off: 0, on: 1, pending: 2
    end
  end

  describe "Associations" do
    [:post_tags, :notifications, :post_marks, :post_likes].each do |model|
      it {have_many(model).dependent(:destroy)}
    end

    it "has many tags" do
      is_expected.to have_many(:tags).through :post_tags
    end

    it "has many mark_users" do
      is_expected.to have_many(:mark_users).through(:post_marks).source :user
    end

    it "has many like_users" do
      is_expected.to have_many(:like_users).through(:post_likes).source :user
    end

    it "belong to user" do
      is_expected.to belong_to(:user).counter_cache :posts_count
    end

    it "belong to topic" do
      is_expected.to belong_to :topic
    end
  end

  describe "Nested attributes" do
    it "tag subject" do
      is_expected.to accept_nested_attributes_for(:tags).allow_destroy true
    end
  end

  describe "Scopes" do
    describe ".order_created_at" do
      it "order by created date" do
        expect(Post.order_created_at.pluck(:created_at))
            .to eq ["15-09-2020".to_date, "14-09-2020".to_date]
      end
    end

    describe ".order_updated_at" do
      it "order by updated date" do
        expect(Post.order_updated_at.pluck(:updated_at))
            .to eq ["15-09-2020".to_date, "14-09-2020".to_date]
      end
    end

    describe ".by_title" do
      it "by title if title present" do
        expect(Post.by_title("Minh Thong").pluck(:title)).to eq ["Minh Thong"]
      end

      it "by title if title is not present" do
        expect(Post.by_title(nil).count).to eq post_count
      end
    end

    describe ".by_topic_id" do
      it "by topic id if topic id present" do
        expect(Post.by_topic_id(post_three.topic_id).pluck(:topic_id)).to eq [post_three.topic_id]
      end

      it "by topic id if topic id not present" do
        expect(Post.by_topic_id(nil).count).to eq post_count
      end
    end

    describe ".by_topics" do
      it "by topics" do
        expect(Post.by_topics(post_two.topic_id).pluck(:topic_id)).to eq [post_two.topic_id]
      end
    end

    describe ".by_users" do
      it "by users" do
        expect(Post.by_users(post_two.user_id).pluck(:user_id)).to eq [post_two.user_id]
      end
    end

    describe ".by_ids" do
      it "by ids" do
        expect(Post.by_ids(post_two.id).pluck(:id)).to eq [post_two.id]
      end
    end

    describe ".in_homepage" do
      before :each do
        post_three.on!
        post_two.on!
      end

      it "in homepage" do
        expect(Post.in_homepage(post_two.topic_id, post_three.user_id).pluck(:id)).to eq [post_two.id, post_three.id]
      end
    end
  end

  describe "#reject_tags" do
    context "reject tags" do
      it "return true" do
        post_three.instance_eval{ reject_tags({name: nil}) }
        post_three.instance_eval{ attributes[:name].blank? }.should eql true
      end
    end
  end
end
