#![feature(plugin)]
#![plugin(rocket_codegen)]

extern crate rocket;

use rocket::response::NamedFile;
use rocket::Request;
use std::io;
use std::path::{Path, PathBuf};

#[get("/")]
fn index() -> io::Result<NamedFile> {
    NamedFile::open("html/under-construction.html")
}

#[get("/<file..>")]
fn files(file: PathBuf) -> Option<NamedFile> {
    NamedFile::open(file).ok()
}

#[error(404)]
fn not_found(_req: &Request) -> Option<NamedFile> {
    NamedFile::open(Path::new("html").join("404.html")).ok()
}

fn main() {
    rocket::ignite()
        .mount("/", routes![index, files])
        .catch(errors![not_found])
        .launch();
}
