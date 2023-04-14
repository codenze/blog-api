# reports_controller.rb
class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :update, :destroy]

  # GET /reports
  def index
    @reports = Report.all.order(updated_at: :desc)
    render json: @reports.as_json(include: [:user, post: { include: [:user] }, comment: { include: [:user, post: { include: [:user] }] } ])
  end

  def user_reports
    @user = User.find(params[:user_id])
    @reports = @user.reports.order(updated_at: :desc)
    render json: @reports.as_json(include: [:user, post: { include: [:user] }, comment: { include: [:user, post: { include: [:user] }] } ])
  end

  def post_reports
    @post = Post.find(params[:post_id])
    @reports = @post.reports.order(updated_at: :desc)
    render json: @reports.as_json(include: [:user, post: { include: [:user] }, comment: { include: [:user, post: { include: [:user] }] } ])
  end

  def comment_reports
    @comment = Comment.find(params[:comment_id])
    @reports = @comment.reports.order(updated_at: :desc)
    render json: @reports.as_json(include: [:user, post: { include: [:user] }, comment: { include: [:user, post: { include: [:user] }] } ])
  end

  # GET /reports/1
  def show
    render json: @report.as_json(include: [:user, post: { include: [:user] }, comment: { include: [:user, post: { include: [:user] }] } ])
  end

  # POST /reports
  def update
    @report = Report.new(report_params)

    if @report.save
      render json: @report.as_json(include: [:user, post: { include: [:user] }, comment: { include: [:user, post: { include: [:user] }] } ]), status: :created, location: @report
    else
      render json: @report.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reports/1
  def create
    user_id = report_params[:user_id]
    post_id = report_params[:post_id]
    comment_id = report_params[:comment_id]

    if user_id.present? && post_id.present?
      report = Report.find_by(user_id: user_id, post_id: post_id)
    elsif user_id.present? && comment_id.present?
      report = Report.find_by(user_id: user_id, comment_id: comment_id)
    end

    if report.present?
      report.status = report.status == "active" ? "inactive" : "active"
      if report.save
        render json: report.as_json(include: [:user, post: { include: [:user] }, comment: { include: [:user] } ])
      else
        render json: report.errors, status: :unprocessable_entity
      end
    else
      @report = Report.new(report_params)
      if @report.save
        render json: @report.as_json(include: [:user, post: { include: [:user] }, comment: { include: [:user, post: { include: [:user] }] } ]), status: :created, location: @report
      else
        render json: @report.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /reports/1
  def destroy
    @report.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def report_params
      params.require(:report).permit(:status, :user_id, :post_id, :comment_id)
    end
end
