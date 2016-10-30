class CommentsController < ApplicationController
  def index
    @comment = Comment.new
  end

  def report
    @comment = Comment.all
  end

  def create
    Comment.create(comment_params.merge(user_id: current_user.id))
    render partial: 'comments/thanks'
  end

  def local_time_refresh
    render partial: 'local_time_refresh'
  end

  private

  def comment_params
    puts params.inspect
    params.require(:comment).permit(:commenter, :body)
  end
end
