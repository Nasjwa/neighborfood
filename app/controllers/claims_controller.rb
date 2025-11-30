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

  # Prevent claiming your own food
  if @food.user == current_user
    return render turbo_stream: turbo_stream.update(
      "claim-modal-body",
      partial: "claims/claim_error",
      locals: { message: "You cannot claim your own food." }
    )
  end

  @claim = current_user.claims.build(claim_params.merge(food: @food))
  @claim.status = "claimed"

  if @claim.save
    # Always turbo: flip modal to confirmation
    render "claims/create"
  else
    render turbo_stream: turbo_stream.update(
      "claim-modal-body",
      partial: "claims/claim_error",
      locals: { message: @claim.errors.full_messages.to_sentence }
    )
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
