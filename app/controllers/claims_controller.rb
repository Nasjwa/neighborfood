class ClaimsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_food

  helper_method :available_times

  def index
    @claims = current_user.claims
                          .includes(food: [{ photos_attachments: :blob }, :reviews ])
                          .order(collect_time: :desc)
  end

  def show
    @food = Food.find(params[:id])
    @available_times = available_times(@food)


    respond_to do |format|
      format.html
      format.turbo_stream do
        render partial: "claims/claiming_food",
              formats: [:html],
              locals: { food: @food, available_times: @available_times }
      end
    end
  end

  def new
    @food  = Food.find(params[:food_id])
    @claim = Claim.new
    @available_times = available_times(@food)

    respond_to do |format|
      format.html
      format.turbo_stream do
        render partial: "claims/claiming_food",
              formats: [:html],
              locals: { food: @food, available_times: @available_times }
      end
    end
  end


  def create
    @food = Food.find(params[:food_id])

    if @food.user == current_user
      return render turbo_stream: turbo_stream.update(
        "claim-modal-body",
        partial: "claims/claim_error",
        locals: { message: "You cannot claim your own food." }
      )
    end

    selected_hour = params[:claim][:collect_time]
    date = @food.start_time.to_date

    collect_time = Time.zone.parse("#{date} #{selected_hour}")

    @claim = current_user.claims.build(
      food: @food,
      collect_time: collect_time,
      status: "claimed"
    )

    if @claim.save
      render "claims/create"
    else
      render turbo_stream: turbo_stream.update(
        "claim-modal-body",
        partial: "claims/claim_error",
        locals: { food: @food, available_times: available_times(@food) }
      )
    end
  end

  def available_times(food)
      Rails.logger.info "START: #{food.start_time}"
  Rails.logger.info "END:   #{food.end_time}"

    start = food.start_time.in_time_zone
    finish = food.end_time.in_time_zone

    return [] if start >= finish

    times = []
    t = start

    while t <= finish
      times << t
      t += 5.minutes
    end

    times
  end

  private

  def set_food
    @food = Food.find(params[:food_id]) if params[:food_id]
  end


  def claim_params
    params.require(:claim).permit(:collect_time)
  end
end
