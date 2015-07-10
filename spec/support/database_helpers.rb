def reset_to_defaults
  create_test_models
end

def create_test_models
  User.delete_all
  Person.delete_all
  Post.delete_all
  Comment.delete_all

  @zeus = User.create!(name: 'Zeus')
  @hera = User.create!(name: 'Hera')
  User.stamper = @zeus.id

  @delynn = Person.create!(name: 'Delynn')
  @nicole = Person.create!(name: 'Nicole')
  Person.stamper = @delynn.id

  @first_post = Post.create!(title: 'a title')
end
