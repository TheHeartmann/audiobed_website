#![feature(plugin, transpose_result)]
#![plugin(rocket_codegen)]

extern crate rocket;

use rocket::response::NamedFile;
use std::io;
use std::path::{Path, PathBuf};

#[derive(Debug)]
struct ContentDir {
    path: PathBuf,
}

impl ContentDir {
    fn new(config_root: &PathBuf, project_root: &PathBuf, content_dir: &PathBuf) -> ContentDir {
        ContentDir {
            path: [config_root, project_root, content_dir].iter().collect(),
        }
    }
}

fn get_elm(content_dir: rocket::State<ContentDir>) -> io::Result<NamedFile> {
    NamedFile::open(
        Path::new(&content_dir.path)
            .join("html")
            .join("index-elm.html"),
    )
}

fn get_yew(content_dir: rocket::State<ContentDir>) -> io::Result<NamedFile> {
    under_construction(content_dir)
}

fn under_construction(content_dir: rocket::State<ContentDir>) -> io::Result<NamedFile> {
    NamedFile::open(
        Path::new(&content_dir.path)
            .join("html")
            .join("under-construction.html"),
    )
}

#[get("/yew")]
fn yew(content_dir: rocket::State<ContentDir>) -> io::Result<NamedFile> {
    get_yew(content_dir)
}

#[get("/yew/<_path..>", rank = 2)]
fn yew_params(_path: PathBuf, content_dir: rocket::State<ContentDir>) -> io::Result<NamedFile> {
    get_yew(content_dir)
}

#[get("/elm")]
fn elm(content_dir: rocket::State<ContentDir>) -> io::Result<NamedFile> {
    get_elm(content_dir)
}

#[get("/elm/<_path..>", rank = 1)]
fn elm_params(_path: PathBuf, content_dir: rocket::State<ContentDir>) -> io::Result<NamedFile> {
    get_elm(content_dir)
}

#[get("/")]
fn index(content_dir: rocket::State<ContentDir>) -> io::Result<NamedFile> {
    NamedFile::open(Path::new(&content_dir.path).join("html").join("index.html"))
}

#[get("/<file..>", rank = 3)]
fn files(file: PathBuf, content_dir: rocket::State<ContentDir>) -> Option<NamedFile> {
    NamedFile::open(Path::new(&content_dir.path).join(file)).ok()
}

#[get("/404")]
fn error_404(content_dir: rocket::State<ContentDir>) -> Option<NamedFile> {
    NamedFile::open(Path::new(&content_dir.path).join("html").join("404.html")).ok()
}

// note: errors do not support state, so error handlers must be kept in a constant folder or redirected
#[error(404)]
fn not_found() -> rocket::response::Redirect {
    rocket::response::Redirect::to("/404")
}

fn get_content_dir(rocket: &rocket::Rocket) -> ContentDir {
    let config_root = rocket.config().root().to_path_buf();
    let content_dir = PathBuf::from(rocket.config().get_str("content_dir").unwrap_or(""));
    let project_root = PathBuf::from(rocket.config().get_str("project_root").unwrap_or(""));
    ContentDir::new(&config_root, &project_root, &content_dir)
}

fn main() {
    rocket::ignite()
        .attach(rocket::fairing::AdHoc::on_attach(|rocket| {
            let content_dir = get_content_dir(&rocket);
            Ok(rocket.manage(content_dir))
        }))
        .mount(
            "/",
            routes![index, elm, elm_params, yew, yew_params, files, error_404],
        )
        .catch(errors![not_found])
        .launch();
}
