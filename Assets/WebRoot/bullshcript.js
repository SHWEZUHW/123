class NewUserPlayer{ 
  constructor() {
    this.avatar = "https://models.readyplayer.me/65f851281bd74c24a4b5be1f.glb";
    
    this.container = document.getElementById("intro");
    this.container.setAttribute("sq-playavatar", "tracking: https://bantr.eu/ARecording/Intro/avatarRecording.trackingsession; audio: https://bantr.eu/ARecording/Intro/avatarRecording.wav; avatar: https://models.readyplayer.me/65f851281bd74c24a4b5be1f.glb")
    // Colors: https://pixeljoint.com/forum/forum_posts.asp?TID=12795
    
    this.setupButton("21.508 1.2 -5.275", "-150", "Login", {
        tracking: "https://bantr.eu/ARecording/Linking/avatarRecording.trackingsession",
        audio: "https://bantr.eu/ARecording/Linking/avatarRecording.wav"
    },"#442434");
    
    this.setupButton("21.426 0.2 5.78", " -150", "Avatar", {
        tracking: "https://bantr.eu/ARecording/Avatar/avatarRecording.trackingsession",
        audio: "https://bantr.eu/ARecording/Avatar/avatarRecording.wav"
    },"#30346d");
    
    this.setupButton("9.219 1.2 5.25", "75", "Have Fun", {
        tracking: "https://bantr.eu/ARecording/HaveFun/avatarRecording.trackingsession",
        audio: "https://bantr.eu/ARecording/HaveFun/avatarRecording.wav"
    },"#4e4a4e");
    
  }
  
  setupButton(position, rotationY, stage, player, color) {
    const buttContainer = document.createElement("a-entity");
    buttContainer.setAttribute("position", position);
    buttContainer.setAttribute("rotation", "-30 " + rotationY + " 0");
    const box = document.createElement("a-box");
    box.setAttribute("sq-collider", "");
    box.setAttribute("sq-interactable", "");
    box.setAttribute("scale", "0.8 0.3 0.1");
    box.setAttribute("color", color);
    buttContainer.appendChild(box);
    const text = document.createElement("a-text");
    text.setAttribute("value", "" + stage);
    text.setAttribute("scale", "0.4 0.4 0.4");
    text.setAttribute("position", "0 0 0.052");
    text.setAttribute("align", "center");
    buttContainer.appendChild(text);
    document.querySelector("a-scene").appendChild(buttContainer);
    let hasClicked = false;
    box.addEventListener("click", () => {
      if(hasClicked) {
        return;
      }
      hasClicked = true;
      window.setText(text.object3D.id, "loading...")
      setTimeout(()=>{
        hasClicked = false;
        window.setText(text.object3D.id, "Parkour Stage " + stage)
      }, 2000);
       window.playAvatar(this.container.object3D.id, player.tracking, player.audio);
       this.playedOne = true;
    });
  }
}

addEventListener("DOMContentLoaded", () => {
  new NewUserPlayer();
});

let EasyMode = false;
AFRAME.registerComponent("toggle-easy", {
  init: function () {
    const text = document.getElementById("easyText");
    this.el.addEventListener("click", () => {
      if(this.el.object3D.userData.isLocalPlayer == false) { return; }
      if (EasyMode) {
        EasyMode = false;
        gravity({x: 0, y: -9.8, z: 0})
        setText(text.object3D.id, "Easy Mode")
      } else {
        EasyMode = true;
        gravity({x: 0, y: -3.71, z: 0})
        setText(text.object3D.id, "Hard Mode")
      }
    });
  },
});