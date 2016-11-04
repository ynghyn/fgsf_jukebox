class CommentsController < ApplicationController
  def index
    @comment = Comment.new
  end

  def report
    @comment = Comment.all
  end

  def create
    if comment_params[:commenter].empty? || comment_params[:body].empty?
      flash[:notice] = "Please fill the form."
      render partial: 'juke/form'
    else
      Comment.create(comment_params.merge(user_id: current_user.id))
      flash[:notice] = "Comment has successfully posted."
      render partial: 'juke/form'
    end
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
