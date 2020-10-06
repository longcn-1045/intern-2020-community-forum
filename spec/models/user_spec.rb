require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) {FactoryBot.build :user}
  let(:invalid_user) {FactoryBot.build :user, name: nil, email: "Abv@gmail.cm"}

  let!(:user_1) {FactoryBot.create :user, name: "User 1",
    created_at: "2020-09-06 05:48:12"}
  let!(:user_2) {FactoryBot.create :user, name: "User 2",
    created_at: "2020-09-07 05:48:12"}

  let!(:post_1) {FactoryBot.create :post, user: user_1}
  let!(:topic_1) {FactoryBot.create :topic}
  let!(:relationship_1) {FactoryBot.create :relationship,
    follower: user_1, followed: user_2}

  describe "Validations" do
    it {is_expected.to validate_presence_of(:name)}

    it {is_expected.to validate_length_of(:name)
      .is_at_most(Settings.user.validates.max_name)}

    it {is_expected.to validate_presence_of(:email)}

    it {is_expected.to validate_length_of(:email)
      .is_at_most(Settings.user.validates.max_email)}

    it "format is invalid" do
      expect(invalid_user).not_to match Settings.user.validates.string
    end
  end

  describe "Associations" do
    [:posts, :activities, :post_marks, :mark_posts, :notifications,
      :post_likes, :like_posts, :user_topics, :topics, :active_relationships,
      :following, :passive_relationships, :followers].each do |model|
      it {have_many(model)}
    end
  end

  describe "Enums" do
    it "status" do
      is_expected.to define_enum_for(:status)
                 .with_values active: 0, block: 1
    end

    it "role" do
      is_expected.to define_enum_for(:role)
                 .with_values member: 0, admin: 1
    end
  end

  describe "Scopes" do
    describe ".order_created_at" do
      it "order by create at" do
        expect(User.order_created_at.first)
          .to eq user_2
      end
    end

    describe ".all_except" do
      it "get all except user" do
        expect(User.all_except(user_1)).not_to include user_1
      end
    end

    describe ".by_user_name" do
      context "when nil param" do
        it "return all record" do
          expect(User.by_user_name(nil)).to eq [user_1, user_2]
        end
      end

      context "when valid param" do
        it "return record" do
          expect(User.by_user_name("User 2").first).to eq user_2
        end
      end
    end

    describe ".by_status" do
      context "when nil param" do
        it "return all record" do
          expect(User.by_status(nil)).to eq [user_1, user_2]
        end
      end

      context "when valid param" do
        before {user_2.block!}
        it "return record" do
          expect(User.by_status("block")).to include user_2
        end
      end
    end

    describe ".by_role" do
      context "when nil param" do
        it "return all record" do
          expect(User.by_role(nil)).to eq [user_1, user_2]
        end
      end

      context "when valid param" do
        before {user_1.admin!}
        it "return record" do
          expect(User.by_role("admin")).to include user_1
        end
      end
    end

    describe ".order_by_post_count" do
      context "when nil param" do
        it "return all record" do
          expect(User.order_by_post_count(nil).last).to eq user_2
        end
      end

      context "when param is desc" do
        it "return record" do
          expect(User.order_by_post_count("desc").first).to eq user_1
        end
      end

      context "when param is asc" do
        it "return record" do
          expect(User.order_by_post_count("asc").first).to eq user_2
        end
      end
    end

    describe ".user_ids" do
      context "when nil param" do
        it "return all record" do
          expect(User.user_ids(nil)).to eq [user_1, user_2]
        end
      end

      context "when valid param" do
        it "return record" do
          expect(User.user_ids(user_2).first).to eq user_2
        end
      end
    end

    describe ".order_by_name" do
      it "return record" do
        expect(User.order_by_name.last).to eq user_2
      end
    end

    describe ".order_followers_count" do
      it "return record" do
        expect(User.order_followers_count.first).to eq user_2
      end
    end

    describe ".not_followers" do
      it "return record" do
        expect(User.not_followers(user_1)).to include user_1
      end
    end
  end

  describe ".sort_type" do
    context "when nil param" do
      it "return all record" do
        expect(User.sort_type(nil).last).to eq user_2
      end
    end

    context "when valid param" do
      it "return sort by create time" do
        expect(User.sort_type("created_at").first).to eq user_2
      end

      it "return sort by alphabet" do
        expect(User.sort_type("alphabet").last).to eq user_2
      end

      it "return sort by followers count" do
        expect(User.sort_type("followers").first).to eq user_2
      end
    end
  end

  describe ".by_follow_status" do
    context "when nil param" do
      it "return all record" do
        expect(User.by_follow_status(nil, nil).last).to eq user_2
      end
    end

    context "when valid param" do
      it "return list following users" do
        expect(User.by_follow_status("on", user_1)).to include user_2
      end

      it "return list unfollowing userst" do
        expect(User.by_follow_status("off", user_1)).not_to include user_2
      end
    end
  end

  describe "#save_post" do
    before {user_1.save_post post_1}
    it "return record include in save post" do
      expect(user_1.mark_posts).to include post_1
    end
  end

  describe "#unsave_post" do
    before {user_1.unsave_post post_1}
    it "return record not include in save post" do
      expect(user_1.mark_posts).not_to include post_1
    end
  end


  describe "#save_post?" do
    context "when nil param" do
      it "return not found record" do
        expect(user_1.save_post?(nil)).to eq false
      end
    end

    context "when valid param" do
      before {user_1.save_post post_1}
      it "return found record" do
        expect(user_1.save_post?(post_1)).to eq true
      end
    end
  end

  describe "#like_post" do
    before {user_1.like_post post_1}
    it "return record include in like post" do
      expect(user_1.like_posts).to include post_1
    end
  end

  describe "#unlike_post" do
    before {user_1.unlike_post post_1}
    it "return record not include in like post" do
      expect(user_1.like_posts).not_to include post_1
    end
  end


  describe "#like_post?" do
    context "when nil param" do
      it "return not found record" do
        expect(user_1.like_post?(nil)).to eq false
      end
    end

    context "when valid param" do
      before {user_1.like_post post_1}
      it "return found record" do
        expect(user_1.like_post?(post_1)).to eq true
      end
    end
  end

  describe "#follow_topic" do
    before {user_1.follow_topic topic_1}
    it "return record include in followed topic" do
      expect(user_1.topics).to include topic_1
    end
  end

  describe "#unfollow_topic" do
    before {user_1.unfollow_topic topic_1}
    it "return record not include in followed topic" do
      expect(user_1.topics).not_to include topic_1
    end
  end


  describe "#follow_topic?" do
    context "when nil param" do
      it "return not found record" do
        expect(user_1.follow_topic?(nil)).to eq false
      end
    end

    context "when valid param" do
      before {user_1.follow_topic topic_1}
      it "return found record" do
        expect(user_1.follow_topic?(topic_1)).to eq true
      end
    end
  end

  describe "#follow" do
    it "return record include in followed users" do
      expect(user_1.following).to include user_2
    end
  end

  describe "#unfollow" do
    before {user_1.unfollow user_2}
    it "return record not include in followed users" do
      expect(user_1.following).not_to include user_2
    end
  end

  describe "#following?" do
    context "when nil param" do
      it "return not found record" do
        expect(user_1.following?(nil)).to eq false
      end
    end

    context "when valid param" do
      before {user_2.follow user_1}
      it "return found record" do
        expect(user_2.following?(user_1)).to eq true
      end
    end
  end

  describe "#author?" do
    context "when nil param" do
      it "return not found author" do
        expect(user_1.author?(nil)).to eq false
      end
    end

    context "when valid param" do
      it "return found author" do
        expect(user_1.author?(post_1)).to eq true
      end
    end
  end

  describe ".order_created_at" do
    before {user_1.admin!}
    it "order by updated at" do
      expect(User.order_updated_at.first).to eq user_1
    end
  end
end
