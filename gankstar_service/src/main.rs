extern crate notify;

use notify::{RecommendedWatcher, Watcher, RecursiveMode};
use std::sync::mpsc::channel;
use std::time::Duration;
use std::env;
use std::path::Path;
use std::fs;

fn watch() -> notify::Result<()> {

    // TODO: In production this should be working dir, find a way to use this in dev and production.
    let mut working_dir = env::current_exe()?;
    //REALLY??? while not __retail__?
    working_dir.pop();
    working_dir.pop();
    working_dir.pop();
    working_dir.pop();
    working_dir.pop();
    working_dir.pop();
    working_dir.pop();
    working_dir.push("WTF");
    working_dir.push("Account");

    // Create a channel to receive the events.
    let (tx, rx) = channel();

    let path = Path::new(&working_dir);
    // Automatically select the best implementation for your platform.
    // You can also access each implementation directly e.g. INotifyWatcher.
    let mut watcher: RecommendedWatcher = Watcher::new(tx, Duration::from_secs(2))?;
    println!("{:?}", working_dir.to_str());
    // Add a path to be watched. All files and directories at that path and
    // below will be monitored for changes.
    watcher.watch(path, RecursiveMode::Recursive)?;

    // This is a simple loop, but you may want to use more complex logic here,
    // for example to handle I/O.
    loop {
        match rx.recv() {
           Ok(event) => {
              match event{
                notify::DebouncedEvent::NoticeWrite(_) => {}
                notify::DebouncedEvent::NoticeRemove(_) => {}
                notify::DebouncedEvent::Write(event) => {
                  println!("Got write event: {:?}", event);
                  let path = Path::new(&event);
                  let filename = path.file_stem().unwrap();
                  if filename == "Gankstars" {
                    handle_event(path);
                  }
                },
                notify::DebouncedEvent::Chmod(_) => {},
                notify::DebouncedEvent::Remove(_) => {}
                notify::DebouncedEvent::Rename(_, _) => {}
                notify::DebouncedEvent::Rescan => {}
                notify::DebouncedEvent::Error(_, _) => {},
                notify::DebouncedEvent::Create(event) => {
                  println!("Got create event: {:?}", event);
                  let path = Path::new(&event);
                  let filename = path.file_stem().unwrap();
                  if filename == "Gankstars" {
                    handle_event(path);
                  }
                }
              }
           },
           Err(e) => println!("watch error: {:?}", e),

        }
    }
}

fn get_token(data: &String) -> String {
  let pattern = r#"["addon_token"] = "#;
  let start_index = data.find(pattern); 
  let uuid_size = 39;
  let mut addon_token: String = data.chars().skip(start_index.unwrap() + pattern.chars().count()).take(uuid_size).collect();
  addon_token = addon_token.replace(&['"', '\\', ','][..], "");
  println!("\n{:?}\n", addon_token);
  return addon_token;
}

fn handle_event(path: &Path) {
  println!("Should handle event: {:?}", path);
  let data = fs::read_to_string(path).expect("Unable to read file");
  let token = get_token(&data);
  let client = reqwest::blocking::Client::new();

  // 3272a63c-ae10-4170-9453-6b15b1b7aee5 <- production
  // 2f817e70-8a4b-4d5e-9138-9fa87099d18b <- dev
  let params = [("auth_token", &token), ("body", &data)];
  let res = client.post("http://127.0.0.1:3000/api/receive")
      .form(&params)
      .send();

  println!("response: {:?}", res);
}

fn main() {
    if let Err(e) = watch() {
        println!("error: {:?}", e)
    }
}