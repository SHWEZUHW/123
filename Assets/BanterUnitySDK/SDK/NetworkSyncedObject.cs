using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(UniqueObjectId))]
public class NetworkSyncedObject : MonoBehaviour
{
    public bool SyncPosition = true;
    public bool SyncRotation = true;
    public bool SyncScale = false;
    public bool TakeOwnershipOnCollision = true;
    public bool TakeOwnershipOnGrab = true;
    public bool KinematicIfNotOwned = false;
}
