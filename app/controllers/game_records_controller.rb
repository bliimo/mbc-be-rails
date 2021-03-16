class GameRecordsController < ApplicationController
  before_action :set_game_record, only: [:show, :edit, :update, :destroy]

  # GET /game_records
  # GET /game_records.json
  def index
    @game_records = GameRecord.all
  end

  # GET /game_records/1
  # GET /game_records/1.json
  def show
  end

  # GET /game_records/new
  def new
    @game_record = GameRecord.new
  end

  # GET /game_records/1/edit
  def edit
  end

  # POST /game_records
  # POST /game_records.json
  def create
    @game_record = GameRecord.new(game_record_params)

    respond_to do |format|
      if @game_record.save
        format.html { redirect_to @game_record, notice: 'Game record was successfully created.' }
        format.json { render :show, status: :created, location: @game_record }
      else
        format.html { render :new }
        format.json { render json: @game_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /game_records/1
  # PATCH/PUT /game_records/1.json
  def update
    respond_to do |format|
      if @game_record.update(game_record_params)
        format.html { redirect_to @game_record, notice: 'Game record was successfully updated.' }
        format.json { render :show, status: :ok, location: @game_record }
      else
        format.html { render :edit }
        format.json { render json: @game_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_records/1
  # DELETE /game_records/1.json
  def destroy
    @game_record.destroy
    respond_to do |format|
      format.html { redirect_to game_records_url, notice: 'Game record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_record
      @game_record = GameRecord.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def game_record_params
      params.require(:game_record).permit(:game_id, :start_time, :winners)
    end
end
