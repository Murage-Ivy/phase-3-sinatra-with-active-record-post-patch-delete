class ApplicationController < Sinatra::Base
  set :default_content_type, "application/json"

  get "/games" do
    games = Game.all.order(:title).limit(10)
    games.to_json
  end

  get "/games/:id" do
    game = Game.find(params[:id])

    game.to_json(only: [:id, :title, :genre, :price], include: {
                   reviews: { only: [:comment, :score], include: {
                     user: { only: [:name] },
                   } },
                 })
  end
  delete "/reviews/:id" do
    # find the review by id
    review = Review.find(params[:id])

    # Delete the reviw from the database
    review.destroy

    # send a respoonse with  the deleted review as a JSON object
    review.to_json
  end

  post "/reviews" do
    review = Review.create(
      score: params[:score],
      comment: params[:comment],
      game_id: params[:game_id],
      user_id: params[:user_id],
    )
    review.to_json
  end

  patch "/reviews/:id" do
    review = Review.find(params[:id])
    # review.comment = params[:comment]
    # review.score = params[:score]
    # review.save
    review.update(
      comment: params[:comment],
      score: params[:score],
    )
    review.to_json
  end
end
