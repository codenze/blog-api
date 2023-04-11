# likes_controller.rb
class LikesController < ApplicationController
  before_action :set_like, only: [:show, :update, :destroy]

  # GET /likes
  def index
    @likes = Like.all
    render json: @likes.as_json(include: [:user, post: { include: [:user] }, comment: { include: [:user, post: { include: [:user] }] } ])
  end

  def user_likes
    @user = User.find(params[:user_id])
    @likes = @user.likes
    render json: @likes.as_json(include: [:user, post: { include: [:user] }, comment: { include: [:user, post: { include: [:user] }] } ])
  end

  def post_likes
    @post = Post.find(params[:post_id])
    @likes = @post.likes
    render json: @likes.as_json(include: [:user, post: { include: [:user] }, comment: { include: [:user, post: { include: [:user] }] } ])
  end

  def comment_likes
    @comment = Comment.find(params[:comment_id])
    @likes = @comment.likes
    render json: @likes.as_json(include: [:user, post: { include: [:user] }, comment: { include: [:user, post: { include: [:user] }] } ])
  end

  # GET /likes/1
  def show
    render json: @like.as_json(include: [:user, post: { include: [:user] }, comment: { include: [:user, post: { include: [:user] }] } ])
  end

  # POST /likes
  def update
    @like = Like.new(like_params)

    if @like.save
      render json: @like.as_json(include: [:user, post: { include: [:user] }, comment: { include: [:user, post: { include: [:user] }] } ]), status: :created, location: @like
    else
      render json: @like.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /likes/1
  def create
    user_id = like_params[:user_id]
    post_id = like_params[:post_id]
    comment_id = like_params[:comment_id]

    if user_id.present? && post_id.present?
      like = Like.find_by(user_id: user_id, post_id: post_id)
    elsif user_id.present? && comment_id.present?
      like = Like.find_by(user_id: user_id, comment_id: comment_id)
    end

    if like.present?
      like.status = like.status == "active" ? "inactive" : "active"
      if like.save
        render json: like.as_json(include: [:user, post: { include: [:user] }, comment: { include: [:user] } ])
      else
        render json: like.errors, status: :unprocessable_entity
      end
    else
      @like = Like.new(like_params)
      if @like.save
        render json: @like.as_json(include: [:user, post: { include: [:user] }, comment: { include: [:user, post: { include: [:user] }] } ]), status: :created, location: @like
      else
        render json: @like.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /likes/1
  def destroy
    @like.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_like
      @like = Like.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def like_params
      params.require(:like).permit(:status, :user_id, :post_id, :comment_id)
    end
end
