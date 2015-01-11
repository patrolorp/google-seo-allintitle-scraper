class KeywordsController < ApplicationController
  # GET /keywords
  # GET /keywords.json
  def index
    @keywords = Keyword.all.paginate(page: params[:page], per_page: per_page)
    @keywords.where!(favorite: true) if params[:favorite]
    @title = 'Keywords Index'

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @keywords }
    end
  end
  
  def excel_output
    @keywords = Keyword.all
    @title = 'Keywords Excel Output'
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /keywords/1
  # GET /keywords/1.json
  def show
    @keyword = Keyword.find(params[:id])
    @title_results = @keyword.title_results.paginate(page: params[:page], per_page: per_page)
    @title = "Showing Keyword: #{@keyword.word}"

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @keyword }
    end
  end

  # GET /keywords/new
  # GET /keywords/new.json
  def new
    @keyword = Keyword.new
    @title = 'New Keyword'
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @keyword }
    end
  end

  # POST /keywords
  # POST /keywords.json
  def create
    @keyword = Keyword.new({word: params[:keyword][:word]})

    respond_to do |format|
      if @keyword.save
        format.html { redirect_to @keyword, notice: 'Keyword was successfully created.' }
        format.json { render json: @keyword, status: :created, location: @keyword }
      else
        format.html { render action: "new" }
        format.json { render json: @keyword.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /keywords/1
  # DELETE /keywords/1.json
  def destroy
    @keyword = Keyword.find(params[:id])
    @keyword.destroy

    respond_to do |format|
      format.html { redirect_to keywords_url }
      format.json { head :no_content }
    end
  end
  
  # POST /keywords/1/remove_allintitle
  # POST /keywords/1/remove_allintitle.json
  def reset_allintitle
    @keyword = Keyword.find(params[:id])
    
    respond_to do |format|
      if @keyword.reset_allintitle
        format.html { redirect_to '/', notice: 'Allintitle number for keyword successfully removed.'}
        format.json { head :no_content }
      else
        format.html { render action: "show" }
        format.json { render json: @keyword.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def switch_favorite
    @keyword = Keyword.find(params[:id])
    
    respond_to do |format|
      if @keyword.switch_favorite
        format.html { redirect_to (params[:index] ? keywords_path : @keyword), notice: 'Favorite Updated!'}
        format.json { render json: {favorite: @keyword.favorite} } # make sure it is returning the correct value!
      else
        format.html { render action: "show" }
        format.json { render json: @keyword.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def get_allintitle
    @keyword = Keyword.find(params[:id])
    
    respond_to do |format|
      if @keyword.get_allintitle
        format.html { redirect_to @keyword, notice: 'Allintitle updated' }
        format.json { head :no_content }
      else
        format.html { render action: 'show' }
        format.json { render json: @keyword.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
    def keyword_params
      params.require(:word).permit(:allintitle, :word)
    end
    
    def per_page
      25
    end
end
