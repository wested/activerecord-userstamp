def define_first_post
  @first_post = Post.create!(title: 'a title')
end

RSpec.configure do |config|
  config.before(:each) do
    User.delete_all
    Person.delete_all
    Post.delete_all
    Comment.delete_all
    User.reset_stamper
    Person.reset_stamper

    @zeus = User.create!(name: 'Zeus')
    @hera = User.create!(name: 'Hera')
    User.stamper = @zeus.id

    @delynn = Person.create!(name: 'Delynn')
    @nicole = Person.create!(name: 'Nicole')
    Person.stamper = @delynn.id
  end
end
