using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightOnOff : MonoBehaviour {

	public GameObject Light1;
	public GameObject Light2;

	public bool Emissive = true;
	public Material Emissive_Mat;
	public Renderer Emissive_Obj;
	public Color Emissive_Color;
	public float Emissive_Int;

	public bool Emissive2 = true;
	public Material Emissive2_Mat;
	public Renderer Emissive2_Obj;
	public Color Emissive2_Color;
	public float Emissive2_Int;

	public bool On = true;

	void OnMouseDown () {
		if ( Light1.activeInHierarchy == false ){
			//if ( On == true ){
			Light1.SetActive (true);
			Light2.SetActive (true);
			EmissiveON ();
			On = !On;
		} else {
			Light1.SetActive (false);
			Light2.SetActive (false);
			EmissiveOFF ();
			On = !On;
		}
	}

	public void EmissiveON (){
		if (Emissive){
			Emissive_Mat.EnableKeyword ("_EMISSION");
			Emissive_Mat.SetColor("_EmissionColor", Emissive_Color*Emissive_Int);
			DynamicGI.SetEmissive(Emissive_Obj,Emissive_Color*Emissive_Int);
		}
		if(Emissive2){
			Emissive2_Mat.EnableKeyword ("_EMISSION");
			Emissive2_Mat.SetColor("_EmissionColor", Emissive2_Color*Emissive2_Int);
			DynamicGI.SetEmissive(Emissive_Obj,Emissive2_Color*Emissive2_Int);
		}
	}

	public void EmissiveOFF (){
		if (Emissive){
			Emissive_Mat.EnableKeyword ("_EMISSION");
			Emissive_Mat.SetColor("_EmissionColor", Emissive_Color*0);
			DynamicGI.SetEmissive(Emissive_Obj,Emissive_Color*0);
		}
		if(Emissive2){
			Emissive2_Mat.EnableKeyword ("_EMISSION");
			Emissive2_Mat.SetColor("_EmissionColor", Emissive2_Color*0);
			DynamicGI.SetEmissive(Emissive_Obj,Emissive2_Color*0);
		}
	}
}
