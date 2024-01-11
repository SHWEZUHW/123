using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Manager : MonoBehaviour {

	//Simple script to change Cameras, Lights and Environments in realtime. I am not a coder.. so if you want change this code as you wish.. and make it better !

	// Skyboxes
	public Material SKY_Day;
	public Material SKY_Evening;
	public Material SKY_Night;
	public Material SKY_LowSun;
	public Material SKY_Cloudy;
	public Material SKY_Stonewall;
	public Material SKY_Sunset;

	// Lights
	public GameObject Light_BedWall_S_Up;
	public GameObject Light_BedWall_S_Down;
	public GameObject Light_BedWall_R_Up;
	public GameObject Light_BedWall_R_Down;
	public GameObject Light_Wall;
	public GameObject Light_TableLamp_L_Spot;
	public GameObject Light_TableLamp_L_Point;
	public GameObject Light_TableLamp_R_Spot;
	public GameObject Light_TableLamp_R_Point;
	public GameObject Light_Leukon_Up;
	public GameObject Light_Leukon_Down;
	public GameObject Light_Ceiling;
	public GameObject Light_Wardrobe_S;
	public GameObject Light_Wardrobe_D;
	public GameObject Light_Mezzanine_UP;
	public GameObject Light_Mezzanine_DOWN;
	public Material Windows_Area_Mat;
	public Renderer Windows_Area1;
	public Renderer Windows_Area2;
	public Renderer Windows_Area3;
	public GameObject Sun1;
	public GameObject Sun2;
	public GameObject Sun3;

	// Cameras
	public Camera CameraMain;
	// Reflection Probe
	public ReflectionProbe Probe_Main;
	public ReflectionProbe Probe_Ceiling;
	public ReflectionProbe Probe_Bed;
	public ReflectionProbe Probe_Mezzanine;
	public ReflectionProbe Probe_Wardrobe;

	// Colors
	public Color Windows_Area_Mat_Day1 = Color.white;
	public Color Windows_Area_Mat_Day2 = Color.white;
	public Color Windows_Area_Mat_Day3 = Color.white;
	// Cameras
	public GameObject Camera1;
	public GameObject Camera2;
	public GameObject Camera3;
	public GameObject Camera4;
	public GameObject Camera5;
	public GameObject Camera6;
	public GameObject Camera7;
	public GameObject Camera8;
	public GameObject Camera9;
	public GameObject Camera10;
	public GameObject CameraDetail1;
	public GameObject CameraDetail2;
	public GameObject CameraDetail3;
	public GameObject CameraDetail4;
	public GameObject CameraDetail5;
	public GameObject CameraDetail6;
	public GameObject CameraDetail7;
	public GameObject CameraDetail8;
	public GameObject CameraDetail9;
	public GameObject CameraDetail10;
	public GameObject CameraDetail11;
	public GameObject CharacterController;
	public GameObject CameraWalk;

    public GameObject FirsePersonAIO;

	void Awake () {
		// Make the game run as fast as possible
		Application.targetFrameRate = 300;
	}

	void Start (){
        CanvasMain.active = false;
        FirsePersonAIO.GetComponent<FirstPersonAIO>().ControllerPause();
        //ProbeUpdate();
        //ENV_Day();
    }

	void Update () {
		if (Input.GetKeyUp ("space")) {
            CloseCanvasMain();
            FirsePersonAIO.GetComponent<FirstPersonAIO>().ControllerPause();
        }
	}

	// Hide all cameras in the scene //
	void HideCameras (){
		GameObject[] gos;
		gos = GameObject.FindGameObjectsWithTag("MainCamera"); 
		foreach (GameObject go in gos){
			go.SetActive (false);
		}
	}

	// Swow the selected Camera  //
	public void Camera1Switch (){
		HideCameras ();
		Camera1.SetActive (true);
	} 

	public void Camera2Switch (){
		HideCameras ();
		Camera2.SetActive (true);
	}

	public void Camera3Switch (){
		HideCameras (); 
		Camera3.SetActive (true);	
	}

	public void Camera4Switch (){
		HideCameras (); 
		Camera4.SetActive (true);	
	}

	public void Camera5Switch (){
		HideCameras (); 
		Camera5.SetActive (true);
	}

	public void Camera6Switch (){
		HideCameras (); 
		Camera6.SetActive (true);	
	}

	public void Camera7Switch (){
		HideCameras (); 
		Camera7.SetActive (true);	
	}

	public void Camera8Switch (){
		HideCameras (); 
		Camera8.SetActive (true);
	}

	public void Camera9Switch (){
		HideCameras (); 
		Camera9.SetActive (true);	
	}

	public void Camera10Switch (){
		HideCameras (); 
		Camera10.SetActive (true);	
	}

	public void CameraDetail1Switch (){
		HideCameras (); 
		CameraDetail1.SetActive (true);	
	}

	public void CameraDetail2Switch (){
		HideCameras (); 
		CameraDetail2.SetActive (true);	
	}

	public void CameraDetail3Switch (){
		HideCameras (); 
		CameraDetail3.SetActive (true);	
	}

	public void CameraDetail4Switch (){
		HideCameras (); 
		CameraDetail4.SetActive (true);	
	}

	public void CameraDetail5Switch (){
		HideCameras (); 
		CameraDetail5.SetActive (true);	
	}

	public void CameraDetail6Switch (){
		HideCameras (); 
		CameraDetail6.SetActive (true);	
	}

	public void CameraDetail7Switch (){
		HideCameras (); 
		CameraDetail7.SetActive (true);	
	}

	public void CameraDetail8Switch (){
		HideCameras (); 
		CameraDetail8.SetActive (true);	
	}

	public void CameraDetail9Switch (){
		HideCameras (); 
		CameraDetail9.SetActive (true);	
	}

	public void CameraDetail10Switch (){
		HideCameras (); 
		CameraDetail10.SetActive (true);	
	}

	public void CameraDetail11Switch (){
		HideCameras (); 
		CameraDetail11.SetActive (true);	
	}
	public void CameraWalkSwitch (){
		HideCameras (); 
		CameraWalk.SetActive (true);
        FirsePersonAIO.GetComponent<FirstPersonAIO>().ControllerPause();
        CanvasMain.active = false;
    }



	/// ////////////////////// Environment switch //////////////////////

	public void ENV_Day(){
		// Turn ON/OFF Lights
		DisableAllLight ();
		Sun1.SetActive (true);

		CameraMain.clearFlags = CameraClearFlags.Skybox;
		RenderSettings.skybox = SKY_Day;
		RenderSettings.ambientIntensity = 1; 

		ProbeUpdate();
		ENV_Day_Setup();
	}
	public void ENV_Evening(){
		// Turn ON/OFF Lights
		DisableAllLight ();
		Light_TableLamp_L_Spot.SetActive (true);
		Light_TableLamp_L_Point.SetActive (true);
		Sun2.SetActive (true);

		CameraMain.clearFlags = CameraClearFlags.Skybox;
		RenderSettings.skybox = SKY_Evening;
		RenderSettings.ambientIntensity = 1; 

		ProbeUpdate();
		ENV_Evening_Setup();
	}

	public void ENV_Night(){
		// Turn ON/OFF Lights
		DisableAllLight ();
		Light_BedWall_S_Up.SetActive (true);
		Light_BedWall_S_Down.SetActive (true);
		Light_BedWall_R_Up.SetActive (true);
		Light_BedWall_R_Down.SetActive (true);
		Light_Wall.SetActive (true);
		INT_Wall_Bed_L.EmissiveON ();
		INT_Wall_Bed_R.EmissiveON ();
		INT_Wall.EmissiveON ();

		CameraMain.clearFlags = CameraClearFlags.Skybox;
		RenderSettings.skybox = SKY_Night;
		RenderSettings.ambientIntensity = 1; 

		ProbeUpdate();
		ENV_Night_Setup();
	}

	public void ENV_LowSun(){
		// Turn ON/OFF Lights

		DisableAllLight ();
		Light_Leukon_Up.SetActive (true);
		Light_Leukon_Down.SetActive (true);
		INT_Leukon.EmissiveON ();


		CameraMain.clearFlags = CameraClearFlags.Skybox;
		RenderSettings.skybox = SKY_LowSun;
		RenderSettings.ambientIntensity = 1; 

		ProbeUpdate();
	}

	public void ENV_Cloudy(){
		// Turn ON/OFF Lights
		DisableAllLight ();
		Light_BedWall_R_Up.SetActive (true);
		Light_BedWall_R_Down.SetActive (true);

		CameraMain.clearFlags = CameraClearFlags.Skybox;
		RenderSettings.skybox = SKY_Cloudy;
		RenderSettings.ambientIntensity = 1; 

		ProbeUpdate();
	}

	public void ENV_Stonewall(){
		// Turn ON/OFF Lights
		DisableAllLight ();

		CameraMain.clearFlags = CameraClearFlags.Skybox;
		RenderSettings.skybox = SKY_Stonewall;
		RenderSettings.ambientIntensity = 1; 

		ProbeUpdate();
		ENV_Day_Setup();
	}

	public void ENV_Sunset(){
		// Turn ON/OFF Lights
		DisableAllLight ();
		Sun3.SetActive (true);

		CameraMain.clearFlags = CameraClearFlags.Skybox;
		RenderSettings.skybox = SKY_Sunset;
		RenderSettings.ambientIntensity = 1; 

		ProbeUpdate();
		ENV_Day_Setup();
	}

	void DisableAllLight (){
		Light_BedWall_S_Up.SetActive (false);
		Light_BedWall_S_Down.SetActive (false);
		Light_BedWall_R_Up.SetActive (false);
		Light_BedWall_R_Down.SetActive (false);
		Light_Wall.SetActive (false);
		Light_TableLamp_L_Spot.SetActive (false);
		Light_TableLamp_L_Point.SetActive (false);
		Light_TableLamp_R_Spot.SetActive (false);
		Light_TableLamp_R_Point.SetActive (false);
		Light_Leukon_Up.SetActive (false);
		Light_Leukon_Down.SetActive (false);
		Light_Ceiling.SetActive (false);
		Light_Wardrobe_S.SetActive (false);
		Light_Wardrobe_D.SetActive (false);
		Light_Mezzanine_UP.SetActive (false);
		Light_Mezzanine_DOWN.SetActive (false);
		Sun1.SetActive (false);
		Sun2.SetActive (false);
		Sun3.SetActive (false);

		INT_Leukon.EmissiveOFF ();
		INT_CeilingLamp.EmissiveOFF ();
		INT_Wall.EmissiveOFF ();
		INT_Wall_Bed_L.EmissiveOFF ();
		INT_Wall_Bed_R.EmissiveOFF ();
		INT_TableLight.EmissiveOFF ();
		INT_Wardrobe.EmissiveOFF ();
		INT_TableLight_R.EmissiveOFF ();
		INT_Mezzanine.EmissiveOFF ();
	}

	void ENV_Day_Setup (){
		Windows_Area_Mat.EnableKeyword ("_EMISSION");
		Windows_Area_Mat.SetColor("_EmissionColor", Windows_Area_Mat_Day1*2);
		Windows_Area_Mat.SetColor("_EmissionColor", Windows_Area_Mat_Day2*2);
		Windows_Area_Mat.SetColor("_EmissionColor", Windows_Area_Mat_Day3*2);
		// Inutile per Invisibili
		DynamicGI.SetEmissive(Windows_Area1,Windows_Area_Mat_Day1);
		DynamicGI.SetEmissive(Windows_Area2,Windows_Area_Mat_Day2);
		DynamicGI.SetEmissive(Windows_Area3,Windows_Area_Mat_Day3);

		//RendererExtensions.UpdateGIMaterials (Windows_Area1);
		//RendererExtensions.UpdateGIMaterials (Windows_Area2);
		//RendererExtensions.UpdateGIMaterials (Windows_Area3);
		//DynamicGI.UpdateEnvironment();

	}
	void ENV_Evening_Setup (){
		Windows_Area_Mat.EnableKeyword ("_EMISSION");
		Windows_Area_Mat.SetColor("_EmissionColor", Windows_Area_Mat_Day1*0);
		Windows_Area_Mat.SetColor("_EmissionColor", Windows_Area_Mat_Day2*0);
		Windows_Area_Mat.SetColor("_EmissionColor", Windows_Area_Mat_Day3*0);
		// Inutile per Invisibili
		DynamicGI.SetEmissive(Windows_Area1,Windows_Area_Mat_Day1*0);
		DynamicGI.SetEmissive(Windows_Area2,Windows_Area_Mat_Day2*0);
		DynamicGI.SetEmissive(Windows_Area3,Windows_Area_Mat_Day3*0);

		//RendererExtensions.UpdateGIMaterials (Windows_Area1);
		//RendererExtensions.UpdateGIMaterials (Windows_Area2);
		//RendererExtensions.UpdateGIMaterials (Windows_Area3);
		//DynamicGI.UpdateEnvironment();


	}

	void ENV_Night_Setup (){
		Windows_Area_Mat.EnableKeyword ("_EMISSION");
		Windows_Area_Mat.SetColor("_EmissionColor", Windows_Area_Mat_Day1*0);
		Windows_Area_Mat.SetColor("_EmissionColor", Windows_Area_Mat_Day2*0);
		Windows_Area_Mat.SetColor("_EmissionColor", Windows_Area_Mat_Day3*0);
		// Inutile per Invisibili
		DynamicGI.SetEmissive(Windows_Area1,Windows_Area_Mat_Day1*0);
		DynamicGI.SetEmissive(Windows_Area2,Windows_Area_Mat_Day2*0);
		DynamicGI.SetEmissive(Windows_Area3,Windows_Area_Mat_Day3*0);

		//RendererExtensions.UpdateGIMaterials (Windows_Area1);
		//RendererExtensions.UpdateGIMaterials (Windows_Area2);
		//RendererExtensions.UpdateGIMaterials (Windows_Area3);
		//DynamicGI.UpdateEnvironment();

	}

	void ProbeUpdate(){
		Probe_Main.RenderProbe();
		Probe_Ceiling.RenderProbe();
		Probe_Bed.RenderProbe();
		Probe_Mezzanine.RenderProbe();
		Probe_Wardrobe.RenderProbe();
	}

	public LightOnOff INT_Leukon;
	public LightOnOff INT_CeilingLamp;
	public LightOnOff INT_Wall;
	public LightOnOff INT_Wall_Bed_L;
	public LightOnOff INT_Wall_Bed_R;
	public LightOnOff INT_TableLight;
	public LightOnOff INT_Wardrobe;
	public LightOnOff INT_TableLight_R;
	public LightOnOff INT_Mezzanine;

	// CLOSE Startup Info
	public GameObject CanvasInfo;
    public GameObject CanvasMain;

	public void CloseCanvasInfo (){
		CanvasInfo.active = false;
        FirsePersonAIO.GetComponent<FirstPersonAIO>().ControllerPause();
    }

    public void CloseCanvasMain()
    {
        CanvasMain.active = !CanvasMain.active;
    }


}
