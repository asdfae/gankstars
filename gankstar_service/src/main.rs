extern crate notify;

use notify::{RecommendedWatcher, Watcher, RecursiveMode};
use std::sync::mpsc::channel;
use std::time::Duration;
use std::path::Path;
use std::fs;
use wfd::{DialogParams, FOS_PICKFOLDERS};

fn watch() -> notify::Result<()> {

    //TODO: save chosen path for future starts
    let params = DialogParams {
        options: FOS_PICKFOLDERS,
        .. Default::default()
    };

    let dialog_result = wfd::open_dialog(params);
    let mut working_dir = dialog_result.unwrap().selected_file_path;
    
    working_dir.push("_retail_");
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
  let pattern = r#"["AddonToken"] = "#;
  let start_index = data.find(pattern); 
  if start_index == None {
    return "".to_string();
  }

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
  if token != "" {
    let params = [("auth_token", &token), ("body", &data)];
    //let res = client.post("http://127.0.0.1:3000/api/receive")
    let res = client.post("https://ganksta.rs/api/receive")
        .form(&params)
        .send();

    println!("response: {:?}", res);
  }

}

fn main() {
    if let Err(e) = watch() {
        println!("error: {:?}", e)
    }
}