# Pixabay
Fetch pictures from pixabay

# ARCHITECTURE and Packeges 
The project uses two packages NetworkLayer and Components. 
For Architecture it uses MVVM with Combine.
For Dependency injection it uses Resolver.

# Packages - NetworkLayer
With NetworkLayer and Async await, user can easily fetch response as it is syncronous.
because extensions of URLRequest, URLComponent and URLQuery, user can use enum cases to call service easily. 
  Cons - 
  Because of those enums network layer know about url path and query keys
  Pros - 
  It's very easy to use, pass some arguments, enums are safe and fast. 

# Packages - Components
Components package is key for project UI. It knows about generic table view protocols, it uses components and those components are used in tableViewCell.
Component has dependency on SDWebImage - To fetch image from url and also SNapKit which is important for autolayout. 

