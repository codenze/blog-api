# comments_controller.rb
class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :update, :destroy]

  # GET /comments
  def index
    @comments = Comment.all.order(updated_at: :desc)
    render json: @comments.as_json(include: [:user, :parent_comment, replies: { include: [:user] }, post: { include: [:user] } ])
  end

  def post_comments
    @post = Post.find(params[:post_id])
    @comments = @post.comments.order(updated_at: :desc)
    render json: @comments.as_json(include: [:post, :user, :parent_comment, replies: { include: [:user] }])
  end

  def index_comments
    @comments = Comment.all.order(updated_at: :desc)
    render json: @comments.as_json(include: [:user, :parent_comment, replies: { include: [:user] }, post: { include: [:user] } ])
  end

  def user_comments
    @user = User.find(params[:user_id])
    @comments = @user.comments.order(updated_at: :desc)
    render json: @comments.as_json(include: [:user, :parent_comment, replies: { include: [:user] }, post: { include: [:user] } ])
  end

  # GET /comments/1
  def show
    render json: @comment.as_json(include: [:post, :user, :parent_comment, replies: { include: [:user] }])
  end

  # POST /comments
  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      render json: @comment.as_json(include: [:post, :user, :parent_comment, replies: { include: [:user] }]), status: :created, location: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      render json: @comment.as_json(include: [:post, :user, :parent_comment, replies: { include: [:user] }])
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:body, :status, :user_id, :post_id, :parent_comment_id)
    end
end
