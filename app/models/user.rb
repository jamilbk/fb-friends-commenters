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

  def friends_name(id)
    @friends_name ||= graph.get_object(id)
    # sometimes objects returned are only names
    if @friends_name['name']
      @friends_name['name']
    else
      @friends_name
    end
  end

  def friends_comment_stats(id)
    @feed ||= graph.get_connections(id, 'feed', :limit => 200)
    @stats ||= stats_for_feed(@feed)
  end

  def likes_by_category
    @likes_by_category ||= likes.sort_by {|l| l['name']}.group_by {|l| l['category']}.sort
  end

  protected

    def stats_for_feed(feed)
      return nil if feed.nil?
      stats = {}
      @feed.each do |story|
        comments = story['comments']['data']
        # call me crazy, but i've noticed the "count" value reported by FB is
        # incorrect here.
        if comments and comments.size > 0
          comments.each do |comment|
            id = comment['from']['id']
            name = comment['from']['name']
            if stats.has_key? id
              stats[id][:count] += 1
            else
              stats[id] = {:name => name, :count => 1}
            end
          end
        end
      end
      stats.sort {|a,b| b[1][:count] <=> a[1][:count] }
    end
end
