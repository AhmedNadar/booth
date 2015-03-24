class CommentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_commentable

  def index
    @commentable = Post.find(params[:post_id])
    @comments = @commentable.comments
  end

  def new
    @comment = @commentable.comments.new
  end

  def create
    @user = current_user
    @comment = @commentable.comments.new(comments_params)
    @comments = @user.posts.to_a.collect{|v| v.comments.to_a }.flatten
    @comment.user_id = @user.id

    if @comment.save
      redirect_to @commentable, notice: 'Thank you for good comment!'
    else
      # redirect_to post_path(@post), notice: "You didn't write any comments!"
      redirect_to :new, notice: "You didn't write any comments!"
    end
  end

  # def destroy
  #   @commentable = Post.find(params[:post_id])
  #   @comment = @commentable.comments.find(params[:id])
  #   @comment.destroy
  #   redirect_to post_url
  # end

  private
  def comments_params
    params.require(:comment).permit(:body)
  end

  def load_commentable
    resource, id = request.path.split('/')[1,2] # /post/1
    @commentable = resource.singularize.classify.constantize.find(id) # Post.find(1)
  end
end