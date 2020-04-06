
(function(){
  // Your web app's Firebase configuration
	const firebaseConfig = {
    apiKey: "AIzaSyAnovu3lcdiNmMMzS7xi1WM2LssMPFKSMk",
    authDomain: "minjok-herald.firebaseapp.com",
    databaseURL: "https://minjok-herald.firebaseio.com",
    projectId: "minjok-herald",
    storageBucket: "minjok-herald.appspot.com",
  };
  // Initialize Firebase
  firebase.initializeApp(firebaseConfig);
      
   var db = firebase.firestore();

  const title = document.getElementById('title');
  const name = document.getElementById('name');
  const tag = document.getElementById('tag');
  const image = document.getElementById('image');
  const content = document.getElementById('content');
  const key = document.getElementById('key');

  const submitbtn = document.getElementById('submit');

  submitbtn.addEventListener('click', e => {
    const _title = title.value;
    const _name = name.value;
    const _tag = tag.value;
    const _image = image.value;
    const _content = content.value;
    const _key = key.value;

    var data = {
      title : _title,
      name : _name,
      tags : [_tag],
      url : _image,
      contents : _content,
      passcode : _key,
      timestamp : Date.now()
    }
    
    console.log(data);
    db.collection('news').add(data);

    location.reload();
  })


}());
    

  
      
  
      
  
  
  