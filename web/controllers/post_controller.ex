defmodule Firstep.PostController do
  use Firstep.Web, :controller
  alias Firstep.Post
  alias Firstep.User
  plug :scrub_params, "post" when action in [:create, :update]
  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params, conn.assigns.current_user])
  end
  def index(conn, params, _current_user) do
    user_id = params["user_id"]
    if user_id == nil do
     posts = Repo.all(Post)
    else
        user = User |> Repo.get!(user_id)
        posts =
          user
          |> user_posts
          |> Repo.all
     end
    render(conn, "index.html", posts: posts)
  end
  def show(conn, %{"id" => id},  _current_user) do
    post = Post |> Repo.get!(id) |> Repo.preload(:user)
    user = post.user
    render(conn, "show.html", post: post, user: user)
  end
  def new(conn, _params, current_user) do
    changeset =
      current_user
      |> build_assoc(:posts)
      |> Post.changeset
    render(conn, "new.html", changeset: changeset)
  end
  def create(conn, %{"post" => post_params}, current_user) do
    changeset =
      current_user
      |> build_assoc(:posts)
      |> Post.changeset(post_params)
    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Post was created successfully")
        |> redirect(to: user_post_path(conn, :index, current_user.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
  def edit(conn, %{"id" => id}, current_user) do
    post = Repo.get(Post, id)
    changeset = Post.changeset(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end
  def update(conn, %{"id" => id, "post" => post_params},
                                                      current_user) do
    post = current_user |> user_post_by_id(id)
    changeset = Post.changeset(post, post_params)
    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Post was updated successfully")
        |> redirect(to: user_post_path(conn, :show, current_user.id,
                                       post.id))
      {:error, changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end
  def delete(conn, %{"id" => id}, current_user) do
    current_user |> user_post_by_id(id) |> Repo.delete!
    conn
    |> put_flash(:info, "Post was deleted successfully")
    |> redirect(to: user_post_path(conn, :index, current_user.id))
  end
  defp user_posts(user) do
    assoc(user, :posts)
  end
  defp user_post_by_id(user, post_id) do
    user
    |> user_posts
    |> Repo.get(post_id)
  end
end