using System;
using System.Threading;
using UnityEngine;

public class Runme : MonoBehaviour
{
    public string BundlePassword = "";
    public string BeeFileURL;
    public CancellationToken cancellationToken;
    public BundledContentHolder.Selector PoliceMode = BundledContentHolder.Selector.System;
    public Vector3 SpawnPosition;
    public Quaternion Rotation;

    [Header("Everything Below Generated")]
    [SerializeField]
    public BasisLoadableBundle LoadedBundled = new BasisLoadableBundle();
    [SerializeField]
    public BasisProgressReport BeeProgressReport = new BasisProgressReport();
    public void Awake()
    {
        BeeProgressReport.OnProgressReport += OnProgressReport;
    }
    public async void OnEnable()
    {
        LoadedBundled.UnlockPassword = BundlePassword;
        LoadedBundled.BasisRemoteBundleEncrypted.RemoteBeeFileLocation = BeeFileURL;
        GameObject CreatedThing = await BasisLoadHandler.LoadGameObjectBundle(LoadedBundled, false, BeeProgressReport, cancellationToken, SpawnPosition, Rotation, Vector3.one, false, PoliceMode, null, false);
       // BasisLoadHandler.load
    }
    public async void OnDisable()
    {
        //removes gameobject instantly or scene
        //then after 30 seconds removes the associated bundle if nothing has used it again.
        //this solution solves thrashing of data.
        await BasisLoadHandler.RequestDeIncrementOfBundle(LoadedBundled);
    }
    public void OnDestroy()
    {
        BeeProgressReport.OnProgressReport -= OnProgressReport;
    }
    private void OnProgressReport(string UniqueID, float progress, string eventDescription)
    {
        BasisDebug.Log($"{UniqueID} {eventDescription} with progress {progress}%");
    }
}