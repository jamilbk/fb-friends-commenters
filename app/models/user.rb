class User
  attr_accessor :uid, :graph

  def initialize(graph, uid)
    @graph = graph
    @uid = uid
  end

  def likes
    @likes ||= graph.get_connections(uid, 'likes')
  end

  def friends
    @friends ||= graph.get_connections(uid, 'friends')
  end

  def friends_posts(friend_id = 208333)
    @friends_posts ||= graph.get_connections(friend_id, 'posts', {:limit => 100})
  end

  def likes_by_category
    @likes_by_category ||= likes.sort_by {|l| l['name']}.group_by {|l| l['category']}.sort
  end
end
