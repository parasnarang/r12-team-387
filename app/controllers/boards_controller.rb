class BoardsController < ApplicationController
  before_filter :signed_in_user
  before_filter :authorized_user, only: [:show]
  before_filter :owns_board, only: [:destroy]
  
  def show
    debugger
    @board = Board.find(params[:id])
    @items = @board.items
    @authorized_uids = @board.authorized_uids.select('uid').pluck(:uid)
    @board_users = []
    @board_users.append(@board.user)
    @authorized_uids.each do |uid|
      user = User.find_by_uid(uid)
      if user
        @board_users.append(user)
      end
    end
  end

  def destroy
    @board = Board.find(params[:id])
    @board.destroy
  end

  def index
    #debugger
    @boards = current_user.boards

    @uid = current_user.uid
    @authorized = AuthorizedUid.find_by_uid(@uid)
    if !@authorized.nil? 
      @invited_boards =  @authorized.boards
      @invited_boards.each do | ib|
        @boards.append(ib)
      end
    end

    if @boards.count == 0 && @authorized.nil?
      flash[:notice] = "Please use the bookmarklet on Flipkart to get started."
    end
  end

  def authorized_uids
    #debugger
    @board = Board.find(params[:board])
    @uids = params[:authorized_uids]
    
    @uids.each do |uid|
      @board.authorized_uids.create uid: uid 
    end

    respond_to do |format|
      format.json { head :ok }
    end
  end

  def authorized_user
    debugger
    @board = Board.find(params[:id])
    logger.info "Board id #{@board.id}"
    logger.info "current_user.uid #{current_user.uid}"
    if current_user != @board.user
      @authorized_uids = @board.authorized_uids.select("uid").pluck(:uid)
      
      unless @authorized_uids.include? current_user.uid
        logger.info "authorized_uids = #{@authorized_uids}"
        flash[:error] = "Access Denied"
        redirect_to root_path
      end
    end
  end

  def owns_board
    @board = Board.find(params[:id])
    unless @board.user == current_user
      redirect_to root_path, notice: "What are you trying to do?"
    end
  end
end
