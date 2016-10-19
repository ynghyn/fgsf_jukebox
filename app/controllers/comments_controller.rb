class CommentsController < ApplicationController
  def index
    @comment = Comment.new
  end

  def create
    Comment.create(comment_params.merge(user_id: current_user.id))
    redirect_to root_path
  end

  private

  def comment_params
    puts params.inspect
    params.require(:comment).permit(:commenter, :body)
  end
end
