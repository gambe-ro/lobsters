class UsersController < ApplicationController
  before_filter :require_logged_in_moderator,
    :only => [ :enable_invitation, :disable_invitation, :ban, :unban ]

  def show
    @showing_user = User.where(:username => params[:username]).first!
    @title = "#{@showing_user.username}"

    respond_to do |format|
      format.html { render :action => "show" }
      format.json { render :json => @showing_user }
    end
  end

  def tree
    @title = I18n.t 'controllers.users_controller.usertitle'

    newest_user = User.last.id

    if params[:by].to_s == "karma"
      content = Rails.cache.fetch("users_by_karma_#{newest_user}",
      :expires_in => (60 * 60 * 24)) {
        @users = User.order("karma DESC, id ASC").to_a
        @user_count = @users.length
        @title << " By Karma"
        render_to_string :action => "list", :layout => nil
      }
      render :text => content, :layout => "application"
    elsif params[:moderators]
      @users = User.where("is_admin = ? OR is_moderator = ?", true, true).
        order("id ASC").to_a
      @user_count = @users.length
      @title = "Moderatori e Amministratori"
      render :action => "list"
    else
      content = Rails.cache.fetch("users_tree_#{newest_user}",
      :expires_in => (60 * 60 * 24)) {
        users = User.order("id DESC").to_a
        @user_count = users.length
        @users_by_parent = users.group_by(&:invited_by_user_id)
        @newest = User.order("id DESC").limit(10)
        render_to_string :action => "tree", :layout => nil
      }
      render :text => content, :layout => "application"
    end
  end

  def invite
    @title = "Trasmetti un Invito"
  end

  def disable_invitation
    target = User.where(:username => params[:username]).first
    if !target
      flash[:error] = "Utente non valido."
      redirect_to "/"
    else
      target.disable_invite_by_user_for_reason!(@user, params[:reason])

      flash[:success] = "L'utente ha disabilitata la possibilità di mandare inviti."
      redirect_to user_path(:user => target.username)
    end
  end

  def enable_invitation
    target = User.where(:username => params[:username]).first
    if !target
      flash[:error] = "Utente non valido."
      redirect_to "/"
    else
      target.enable_invite_by_user!(@user)

      flash[:success] = "L'utente ha la possibilità di creare inviti."
      redirect_to user_path(:user => target.username)
    end
  end

  def ban
    buser = User.where(:username => params[:username]).first
    if !buser
      flash[:error] = "Invalid user."
      return redirect_to "/"
    end

    if !params[:reason].present?
      flash[:error] = "Devi fornire una ragione per il ban."
      return redirect_to user_path(:user => buser.username)
    end

    buser.ban_by_user_for_reason!(@user, params[:reason])

    flash[:success] = "L'utente è stato bannato."
    return redirect_to user_path(:user => buser.username)
  end

  def unban
    buser = User.where(:username => params[:username]).first
    if !buser
      flash[:error] = "Utente non valido."
      return redirect_to "/"
    end

    buser.unban_by_user!(@user)

    flash[:success] = "L'utente è stato sbannato."
    return redirect_to user_path(:user => buser.username)
  end
end
