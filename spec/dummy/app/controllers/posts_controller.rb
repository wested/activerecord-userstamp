class PostsController < ApplicationController
  def edit
    @post = Post.find(params[:id])
    render(inline: "<%= @post.title %>")
  end
  
  def update
    @post = Post.find(params[:id])
    @post.update_attributes(post_params)
    render(inline: "<%= @post.title %>")
  end

  def create
    fail
  end

  protected

  def current_user
    Person.find(session[:person_id])
  end

  def set_stamper
    Person.stamper = current_user
  end

  def reset_stamper
    Person.reset_stamper
  end

  private

  def post_params
    params.require(:post).permit(:title)
  end
end
