require 'spec_helper'

describe User do
  before do
    @graph = mock('graph api')
    @uid = 100003527683805
    @user = User.new(@graph, @uid)
  end

  describe 'retrieving likes' do
    before do
      @likes = [
        {
          "name"=> "Opeth", 
          "category"=> "Musician/band", 
          "id"=> "7496603409", 
          "created_time"=> "2012-02-16T12=>34=>56+0000"
        }
      ]
      @graph.should_receive(:get_connections).with(@uid, 'likes').once.and_return(@likes)
    end

    describe '#likes' do
      it 'should retrieve the likes via the graph api' do
        @user.likes.should == @likes
      end

      it 'should memoize the result after the first call' do
        likes1 = @user.likes
        likes2 = @user.likes
        likes2.should equal(likes1)
      end
    end

    describe '#likes_by_category' do
      it 'should group by category and sort categories and names' do
        @user.likes_by_category.should == [
          ["Musician/band", [
            {
              "name"=> "Opeth", 
              "category"=> "Musician/band", 
              "id"=> "7496603409", 
              "created_time"=> "2012-02-16T12=>34=>56+0000"
            }
          ]]
        ]
      end
    end
  end

  describe 'retrieving friends' do
    before do
      @friends = [
        {
          "name" => "Jamil Elie Bou Kheir",
          "id" => "37510737"
        }
      ]
      @graph.should_receive(:get_connections).with(@uid, 'friends').once.and_return(@friends)
    end

    describe '#friends' do
      it 'should receive the friends via the graph api' do
        @user.friends.should == @friends
      end

      it 'should memoize the result after the first call' do
        friends1 = @user.friends
        friends2 = @user.friends
        friends2.should equal(friends1)
      end
    end

  end
  describe 'retrieving friends names' do
    before do
      @friends_name = "Jamil Elie Bou Kheir"
      @graph.should_receive(:get_object).with(37510737).once.and_return(@friends_name)
    end

    describe '#friends_name(id)' do
      it 'should receive the friends name via the graph api given the friend\'s id' do
        @user.friends_name(37510737).should == @friends_name
      end
    end

  end
end
