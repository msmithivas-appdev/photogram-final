class UserAuthenticationController < ApplicationController
  # Uncomment line 3 in this file and line 5 in ApplicationController if you want to force users to sign in before any other actions.
  skip_before_action(:force_user_sign_in, { :only => [:sign_up_form, :create, :sign_in_form, :create_cookie, :index ] })

  def index
  @list_of_all_users = User.all.order(:username)

    render({ :template => "user_authentication/index.html.erb" })

  end

  def show
    
    @the_user = User.where({ :username => params.fetch("path_id") }).at(0)

    the_id = session[:user_id]
    @current_user = User.where({ :id => the_id }).first

    if @the_user.id == @current_user.id 

      # redirect_to("/", { :notice => "same person"})
      render({ :template => "user_authentication/show.html.erb" })
    else 

      follow_status = FollowRequest.where({ :sender_id => @current_user.id }).where({ :recipient_id => @the_user.id }).at(0)
              if follow_status == nil && @the_user.private == true 

                redirect_to("/", { :notice => "You're not authorized for that"})
              elsif follow_status == nil && @the_user.private == false

                render({ :template => "user_authentication/show.html.erb" })
                # redirect_to("/", { :notice => "something else"})

              # elsif follow_status.status == "pending"
              #   redirect_to("/", { :notice => "You're not authorized for that"})

              else
                render({ :template => "user_authentication/show.html.erb" })
              end
              

    end

  
  
    end

    def show2
    
      @the_user = @current_user
    
        render({ :template => "user_authentication/feed.html.erb" })
    
      end


  
  def sign_in_form
    render({ :template => "user_authentication/sign_in.html.erb" })
  end

  def create_cookie
    user = User.where({ :email => params.fetch("query_email") }).first
    
    the_supplied_password = params.fetch("query_password")
    
    if user != nil
      are_they_legit = user.authenticate(the_supplied_password)
    
      if are_they_legit == false
        redirect_to("/user_sign_in", { :alert => "Incorrect password." })
      else
        session[:user_id] = user.id
      
        redirect_to("/", { :notice => "Signed in successfully." })
      end
    else
      redirect_to("/user_sign_in", { :alert => "No user with that email address." })
    end
  end

  def destroy_cookies
    reset_session

    redirect_to("/", { :notice => "Signed out successfully." })
  end

  def sign_up_form
    render({ :template => "user_authentication/sign_up.html.erb" })
  end

  def create
    @user = User.new
    @user.email = params.fetch("query_email")
    @user.password = params.fetch("query_password")
    @user.password_confirmation = params.fetch("query_password_confirmation")
    @user.username = params.fetch("query_username")
    @user.private = params.fetch("query_private", false)
    @user.comments_count = params.fetch("query_comments_count")
    @user.sent_follow_requests_count = params.fetch("query_sent_follow_requests_count")
    @user.received_follow_requests_count = params.fetch("query_received_follow_requests_count")
    @user.own_photos_count = params.fetch("query_own_photos_count")

    save_status = @user.save

    if save_status == true
      session[:user_id] = @user.id
   
      redirect_to("/", { :notice => "User account created successfully."})
    else
      redirect_to("/user_sign_up", { :alert => @user.errors.full_messages.to_sentence })
    end
  end
    
  def edit_profile_form
    render({ :template => "user_authentication/edit_profile.html.erb" })
  end

  def update2
    @user = @current_user
    @user.username = params.fetch("query_username")
    @user.email = params.fetch("query_email")
    @user.password = params.fetch("query_password")
    @user.password_confirmation = params.fetch("query_password_confirmation")

    @user.private = params.fetch("query_private", false)
    @user.comments_count = params.fetch("query_comments_count")
    @user.sent_follow_requests_count = params.fetch("query_sent_follow_requests_count")
    @user.received_follow_requests_count = params.fetch("query_received_follow_requests_count")
    # @user.own_photos_count = params.fetch("query_own_photos_count")
    
    if @user.valid?
      @user.save

      redirect_to("/", { :notice => "User account updated successfully."})
    else
      render({ :template => "user_authentication/edit_profile_with_errors.html.erb" , :alert => @user.errors.full_messages.to_sentence })
    end
  end

  
  def update
    @user = User.where({ :id => params.fetch("path_id") }).at(0)
    # @user = params.fetch("query_username")
    # @user.email = params.fetch("query_email")
    # @user.password = params.fetch("query_password")
    # @user.password_confirmation = params.fetch("query_password_confirmation")
    @user.username = params.fetch("query_username")
    @user.private = params.fetch("query_private", false)
    # @user.comments_count = params.fetch("query_comments_count")
    # @user.sent_follow_requests_count = params.fetch("query_sent_follow_requests_count")
    # @user.received_follow_requests_count = params.fetch("query_received_follow_requests_count")
    # @user.own_photos_count = params.fetch("query_own_photos_count")
    
    if @user.valid?
      @user.save

      redirect_to("/", { :notice => "User account updated successfully."})
    else
      render({ :template => "user_authentication/edit_profile_with_errors.html.erb" , :alert => @user.errors.full_messages.to_sentence })
    end
  end

  def destroy
    @current_user.destroy
    reset_session
    
    redirect_to("/", { :notice => "User account cancelled" })
  end
 
end
