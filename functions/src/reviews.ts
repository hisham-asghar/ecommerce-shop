import * as functions from 'firebase-functions'

export async function updateRating(change: functions.Change<functions.firestore.DocumentSnapshot>) {

    change.after.ref.id
    const productRatingsRef = change.after.ref.parent
    let numRatings = 0
    let total = 0
    const docRefs = await productRatingsRef.listDocuments()
    for (const docRef of docRefs) {
        const snapshot = await docRef.get()
        const data = snapshot.data()
        if (data !== undefined) {
            total += data.score
            numRatings++
        }
    }
    const avgRating = total / numRatings

    const productRef = productRatingsRef.parent!
    console.log(`${productRef.path} now has ${numRatings} ratings with a ${avgRating} average`)
    await productRef.update({
        avgRating: avgRating,
        numRatings: numRatings
    })
}
