class ClaimsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_food

  def index
    @claims = current_user.claims
                          .includes(food: [{ photos_attachments: :blob }, :reviews ])
                          .order(collect_time: :desc)
  end

  def show
  @food = Food.find(params[:id])

    respond_to do |format|
      format.html # full page claim
      format.js { render partial: "claims/claiming_food", locals: { food: @food } }
    end
  end

  def new
    @food  = Food.find(params[:food_id])
    @claim = Claim.new

    respond_to do |format|
      format.html # normal full-page render
      format.js   { render partial: "claims/claiming_food", locals: { food: @food } }
    end
  end


  def create
    @food = Food.find(params[:food_id])
    
    if @food.user == current_user
      redirect_to @food, alert: "You cannot claim your own food."
      return
    end

    @claim = current_user.claims.build(claim_params.merge(food: @food))
    @claim.food = @food

    # set status
    @claim.status = "claimed"

    if @claim.save
      redirect_to user_path(current_user, tab: "claims"), notice: 'Claim created successfully.'
    else
      Rails.logger.debug "Claim save failed: #{@claim.errors.full_messages.inspect}"
      flash.now[:alert] = @claim.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_food
    @food = Food.find(params[:food_id]) if params[:food_id]
  end

  def claim_params
    params.require(:claim).permit(:collect_time)
  end
end
