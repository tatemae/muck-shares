Rails.application.routes.draw do

  resources :shares, :controller => 'muck/shares'
  resources :users, :controller => 'muck/users' do
    # have to map into the muck/shares controller or rails can't find the shares
    resources :shares, :controller => 'muck/shares'
  end
  
  resources :email_shares, :controller => 'muck/email_shares'
  
end