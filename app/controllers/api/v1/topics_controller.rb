class Api::V1::TopicsController < Api::V1::ApiController
  def index
    if params[:category_id]
      cat = Category.find_by_id(params[:category_id])
      @topics = cat.topics
    else
      @topics = Topic.all
    end
    render :json => @topics.collect {|topic| {:id => topic.id, :name => topic.name}}
  end

  def current_user
  end
end
