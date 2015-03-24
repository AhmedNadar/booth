class PostsController < ApplicationController
  before_action :find_post, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
  before_action :find_user, only: [:new, :create, :upvote, :downvote]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post_redirect, only: [:show]

  def index
    # @posts = Post.all.order("created_at DESC") #order based on creation date
    @posts = Post.all.order(cached_votes_up: :desc) #order based on numbers of votes up
    @posts = Post.paginate(:page => params[:page], :per_page => 1)
    @titles = Post.all
  end

  def show
    @commentable = @post
    @comments = @commentable.comments
    @comment = Comment.new
    @random_post = Post.friendly.where.not(id: @post).order("RANDOM()").first

  end

  def new
    @post = @user.posts.build
  end

  def create
    @post = @user.posts.build(post_params)
    if @post.save
      redirect_to @post
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path
  end


  def upvote
    @post.upvote_by @user
    flash[:notice] = "Thanks for voting #{@user.name}."
    redirect_to :back
  end

  def downvote
    @post.downvote_from @user
    flash[:notice] = "Thanks for voting #{@user.name}."
    redirect_to :back
  end

private
  def post_params
    params.require(:post).permit(:title, :content, :link, :image, :slug)
  end

  def find_post
    @post = Post.friendly.find(params[:id])
  end

  def find_user
    @user = current_user
  end

  def set_post_redirect
    @post = Post.friendly.find(params[:id])
    # If an old id or a numeric id was used to find the record, then
    # the request path will not match the post_path, and we should do
    # a 301 redirect that uses the current friendly id.
    if request.path != post_path(@post)
      redirect_to @post, status: :moved_permanently
    end
  end
end
