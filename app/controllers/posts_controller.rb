# posts_controller.rb
class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :set_user, only: [:usershow, :userupdate]

  # GET /posts
  def index
    @posts = Post.all.order(updated_at: :desc)
    render json: @posts.to_json(include: {
      user: {},
      parent_post: { include: {user: {}}}
    })
  end

  def userindex
    @users = User.all.order(updated_at: :desc)
    render json: @users
  end

  def usershow
    @user = User.find(params[:id])
    render json: @user.as_json(only: [:id, :name, :email, :photo, :role])
  end



  def userupdate
    if @user.update(user_params)
      render json: @user.as_json(only: [:id, :name, :email, :photo, :role])
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end


  def user_posts
    @user = User.find(params[:user_id])
    @posts = @user.posts.order(updated_at: :desc)
    render json: @posts.to_json(include: {
      user: {},
      parent_post: { include: {user: {}}}
    })
  end




  # GET /posts/1
  def show
    render json: @post.to_json(include: {
      user: {},
      parent_post: { include: {user: {}}}
    })
  end

  # POST /posts
  def create
    @post = Post.new(post_params)

    if @post.save
      # render json: @post, status: :created, location: @post
      render json: @post.to_json(include: {
        user: {},
        parent_post: { include: {user: {}}}
      }), status: :created, location: @post

    else
      render json: @post.errors, status: :unprocessable_entity
    end



  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      render json: @post.to_json(include: {
        user: {},
        parent_post: { include: {user: {}}}
      })
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    def set_user
      @user = User.find(params[:id])
    end



    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :photo)
    end

    def post_params
      params.require(:post).permit(:content, :user_id, :status, :post_id, :parent_post_id)
    end
end
